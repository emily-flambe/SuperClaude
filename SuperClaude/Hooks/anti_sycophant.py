#!/usr/bin/env python3
"""
Anti-Sycophant Hook for Claude Code
Detects sycophantic responses and automatically corrects Claude's behavior
"""

import json
import sys
import re
import os
from typing import List, Dict, Tuple
from datetime import datetime

# Configuration
BLOCK_AND_REVISE = True  # If True, blocks and asks for revision. If False, just warns
SENSITIVITY = "medium"    # "low", "medium", or "high" - how aggressive to be

# Sycophantic phrases to detect (case-insensitive)
SYCOPHANTIC_PHRASES = {
    "high_confidence": [
        # These are almost always sycophantic
        r"you[''']re absolutely right",
        r"you[''']re completely right",
        r"you[''']re totally right",
        r"you[''']re entirely correct",
        r"you[''']re absolutely correct",
        r"absolutely brilliant",
        r"that[''']s a brilliant point",
        r"excellent observation",
        r"great catch",
        r"you[''']ve made an excellent point",
        r"that[''']s a fantastic point",
        r"you raise an excellent point",
        r"what a great question",
        r"that[''']s a great question",
        r"excellent question",
        r"fantastic question",
        r"brilliant question",
        r"you[''']re spot on",
        r"you[''']ve hit the nail on the head",
        r"couldn[''']t agree more",
        r"perfectly put",
        r"beautifully put",
        r"excellently stated",
        r"very astute",
        r"keen observation",
        r"sharp observation"
    ],
    "medium_confidence": [
        # These might be sycophantic depending on context
        r"^you[''']re right",
        r"^exactly right",
        r"^that[''']s right",
        r"^good point",
        r"^great point",
        r"^excellent point",
        r"^fair point",
        r"^you make a good point",
        r"^interesting point",
        r"^that[''']s true",
        r"^very true",
        r"^so true",
        r"^absolutely",
        r"^definitely",
        r"^indeed",
        r"^precisely",
        r"^good thinking",
        r"^smart thinking",
        r"^clever thinking",
        r"insightful question",
        r"thoughtful question",
        r"perceptive question",
        r"you[''']ve identified",
        r"you[''']ve correctly identified",
        r"you[''']ve rightly identified"
    ],
    "low_confidence": [
        # These could be legitimate in many contexts
        r"thank you for pointing that out",
        r"thanks for clarifying",
        r"thanks for the correction",
        r"i appreciate the correction",
        r"good idea",
        r"interesting idea",
        r"that makes sense",
        r"i see what you mean",
        r"i understand your point",
        r"that[''']s helpful",
        r"that[''']s useful"
    ]
}

# Phrases that indicate legitimate agreement or acknowledgment (allowlist)
LEGITIMATE_PHRASES = [
    r"mathematically correct",
    r"factually correct",
    r"technically correct",
    r"historically accurate",
    r"scientifically accurate",
    r"your calculation is correct",
    r"the formula is correct",
    r"the code is correct",
    r"that[''']s the correct syntax",
    r"yes, that[''']s how it works",
    r"yes, that[''']s the definition"
]


def load_transcript(transcript_path: str) -> List[Dict]:
    """Load and parse the conversation transcript."""
    try:
        messages = []
        if os.path.exists(transcript_path):
            with open(transcript_path, 'r') as f:
                for line in f:
                    if line.strip():
                        try:
                            messages.append(json.loads(line))
                        except json.JSONDecodeError:
                            continue
        return messages
    except Exception as e:
        print(f"Error loading transcript: {e}", file=sys.stderr)
        return []


def extract_claude_response(messages: List[Dict]) -> str:
    """Extract the most recent Claude response from messages."""
    # Look for the last assistant message
    for message in reversed(messages):
        if isinstance(message, dict):
            # Handle Claude Code transcript format
            if message.get('type') == 'assistant' and 'message' in message:
                msg = message['message']
                if isinstance(msg, dict) and msg.get('role') == 'assistant':
                    content = msg.get('content', '')
                    if isinstance(content, list):
                        # Content might be a list of content blocks
                        text_parts = []
                        for block in content:
                            if isinstance(block, dict) and block.get('type') == 'text':
                                text_parts.append(block.get('text', ''))
                        return ' '.join(text_parts)
                    return str(content)
            # Handle direct role format
            elif message.get('role') == 'assistant':
                content = message.get('content', '')
                if isinstance(content, list):
                    text_parts = []
                    for block in content:
                        if isinstance(block, dict) and block.get('type') == 'text':
                            text_parts.append(block.get('text', ''))
                    return ' '.join(text_parts)
                return str(content)
            # Alternative format
            elif message.get('type') == 'assistant_message':
                return message.get('message', '')
    return ""


def check_for_legitimate_context(text: str, phrase_match: str) -> bool:
    """Check if the matched phrase appears to be in a legitimate context."""
    # Check if it's part of a legitimate agreement
    for legitimate in LEGITIMATE_PHRASES:
        if re.search(legitimate, text, re.IGNORECASE):
            return True
    
    # Check if it's in quotes (might be quoting someone)
    if f'"{phrase_match}"' in text or f"'{phrase_match}'" in text:
        return True
    
    # Check if it's preceded by "not" or "don't think"
    negation_patterns = [
        r"not\s+" + re.escape(phrase_match),
        r"don[''']t\s+think\s+" + re.escape(phrase_match),
        r"wouldn[''']t\s+say\s+" + re.escape(phrase_match)
    ]
    for pattern in negation_patterns:
        if re.search(pattern, text, re.IGNORECASE):
            return True
    
    return False


def detect_sycophantic_language(text: str) -> Tuple[bool, List[str], str]:
    """
    Detect sycophantic language in text.
    Returns: (is_sycophantic, matched_phrases, confidence_level)
    """
    if not text:
        return False, [], ""
    
    matched_phrases = []
    highest_confidence = ""
    
    # Check each confidence level based on sensitivity setting
    levels_to_check = []
    if SENSITIVITY == "high":
        levels_to_check = ["high_confidence", "medium_confidence", "low_confidence"]
    elif SENSITIVITY == "medium":
        levels_to_check = ["high_confidence", "medium_confidence"]
    else:  # low
        levels_to_check = ["high_confidence"]
    
    for confidence_level in levels_to_check:
        for pattern in SYCOPHANTIC_PHRASES[confidence_level]:
            matches = re.finditer(pattern, text, re.IGNORECASE | re.MULTILINE)
            for match in matches:
                matched_text = match.group(0)
                # Check if this is in a legitimate context
                if not check_for_legitimate_context(text, matched_text):
                    matched_phrases.append(matched_text)
                    if not highest_confidence:
                        highest_confidence = confidence_level
    
    return len(matched_phrases) > 0, matched_phrases, highest_confidence




def main():
    """Main hook function."""
    try:
        # Read input from Claude Code
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON input: {e}", file=sys.stderr)
        sys.exit(1)
    
    
    # Extract relevant information
    transcript_path = input_data.get('transcript_path', '')
    session_id = input_data.get('session_id', '')
    stop_hook_active = input_data.get('stop_hook_active', False)
    
    # Don't run if we're already in a stop hook loop
    if stop_hook_active:
        sys.exit(0)
    
    # Load and analyze transcript
    messages = load_transcript(transcript_path)
    if not messages:
        sys.exit(0)
    
    # Get Claude's latest response
    claude_response = extract_claude_response(messages)
    
    
    if not claude_response:
        sys.exit(0)
    
    # Check for sycophantic language
    is_sycophantic, matched_phrases, confidence = detect_sycophantic_language(claude_response)
    
    
    if is_sycophantic:
        
        if BLOCK_AND_REVISE:
            # Create feedback for Claude
            phrases_list = "\n  - ".join(matched_phrases)
            
            # Add visible notification
            import subprocess
            try:
                # Send notification to terminal (works on macOS)
                subprocess.run(['osascript', '-e', f'display notification "Anti-sycophant hook triggered: {matched_phrases[0]}" with title "Claude Code Hook"'], 
                             capture_output=True, timeout=1)
            except:
                pass  # Fail silently if notification doesn't work
            
            output = {
                "decision": "block",
                "reason": (
                    "🚫 ANTI-SYCOPHANT HOOK ACTIVATED\n"
                    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
                    f"Detected phrases: {', '.join(matched_phrases)}\n"
                    f"Confidence level: {confidence}\n"
                    f"Timestamp: {datetime.now().strftime('%H:%M:%S')}\n"
                    "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
                    "⚠️ BEHAVIORAL CORRECTION: Your response contained sycophantic language. "
                    "Please revise your response to:\n"
                    "1. Focus on technical accuracy and facts\n"
                    "2. Provide objective analysis without excessive agreement\n"
                    "3. Maintain a professional, analytical tone\n\n"
                    "Revise your response without sycophantic language."
                )
            }
            
            print(json.dumps(output))
            sys.exit(0)
        else:
            # Just warn to stderr (visible in transcript mode)
            phrases_list = ", ".join(matched_phrases)
            print(f"⚠️ Sycophantic language detected: {phrases_list}", file=sys.stderr)
            sys.exit(0)
    
    # No sycophantic language detected
    sys.exit(0)


if __name__ == "__main__":
    main()
