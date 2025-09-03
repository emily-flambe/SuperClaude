"""
Scripts component for SuperClaude deterministic script installation
"""

from pathlib import Path
from typing import Dict, List, Tuple
import stat
import os
from ..base.component import Component


class ScriptsComponent(Component):
    """SuperClaude deterministic scripts component"""
    
    def get_metadata(self) -> Dict:
        """Get component metadata"""
        return {
            'name': 'scripts',
            'description': 'Deterministic bash scripts for SuperClaude commands',
            'version': '1.0.0',
            'author': 'SuperClaude Team'
        }
    
    def get_dependencies(self) -> List[str]:
        """Scripts component has no dependencies"""
        return []
    
    def install(self) -> bool:
        """
        Install scripts component
        
        Returns:
            bool: True if installation successful
        """
        try:
            self.logger.info("Installing Scripts component...")
            
            # Create scripts directory
            scripts_dir = self.install_dir / "scripts"
            
            # Create directory if it doesn't exist
            if self.file_manager.create_directory(scripts_dir):
                self.logger.debug(f"Created scripts directory at {scripts_dir}")
            
            # Get all script files
            source_dir = self._get_source_directory()
            script_files = list(source_dir.glob("*.sh"))
            
            if not script_files:
                self.logger.warning("No script files found to install")
                return True
            
            # Copy all script files
            success_count = self._copy_script_files(script_files, scripts_dir)
            
            if success_count == len(script_files):
                self.logger.success(
                    f"Scripts component installed successfully ({success_count} scripts)"
                )
                return True
            else:
                self.logger.error(
                    f"Scripts component installation incomplete: "
                    f"{success_count}/{len(script_files)} scripts installed"
                )
                return False
                
        except Exception as e:
            self.logger.error(f"Failed to install scripts component: {e}")
            return False
    
    def _copy_script_files(self, files: List[Path], target_dir: Path) -> int:
        """
        Copy script files to target directory with executable permissions
        
        Args:
            files: List of script file paths
            target_dir: Target directory
            
        Returns:
            Number of successfully copied files
        """
        success_count = 0
        
        for source in files:
            target = target_dir / source.name
            
            self.logger.debug(f"Copying {source.name} to {target}")
            
            if self.file_manager.copy_file(source, target):
                # Make script executable
                try:
                    current_permissions = stat.S_IMODE(os.lstat(target).st_mode)
                    os.chmod(target, current_permissions | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)
                    success_count += 1
                    self.logger.debug(f"Successfully copied and made executable: {source.name}")
                except Exception as e:
                    self.logger.warning(f"Failed to set executable permissions on {target}: {e}")
                    # Still count as success if copy worked
                    success_count += 1
            else:
                self.logger.error(f"Failed to copy {source.name}")
        
        return success_count
    
    def uninstall(self) -> bool:
        """
        Uninstall scripts component
        
        Returns:
            bool: True if uninstallation successful
        """
        try:
            self.logger.info("Uninstalling Scripts component...")
            
            scripts_dir = self.install_dir / "scripts"
            
            if not scripts_dir.exists():
                self.logger.info("Scripts directory doesn't exist, nothing to uninstall")
                return True
            
            # Remove all script files
            removed_count = 0
            for script_file in scripts_dir.glob("*.sh"):
                if self.file_manager.remove_file(script_file):
                    removed_count += 1
                    self.logger.debug(f"Removed {script_file.name}")
            
            # Try to remove directory if empty
            try:
                scripts_dir.rmdir()
                self.logger.debug(f"Removed empty scripts directory")
            except OSError:
                self.logger.debug("Scripts directory not empty, keeping it")
            
            self.logger.success(f"Scripts component uninstalled ({removed_count} files removed)")
            return True
            
        except Exception as e:
            self.logger.error(f"Failed to uninstall scripts component: {e}")
            return False
    
    def update(self, current_version: str, target_version: str) -> bool:
        """
        Update scripts component
        
        Args:
            current_version: Current installed version
            target_version: Target version to update to
            
        Returns:
            bool: True if update successful
        """
        try:
            self.logger.info(f"Updating Scripts component from {current_version} to {target_version}")
            
            if current_version == target_version:
                self.logger.info(f"Scripts component already at version {target_version}")
                return True
            
            # For scripts, we can simply reinstall to update
            if self.uninstall() and self.install():
                self.logger.success(f"Scripts component updated to version {target_version}")
                return True
            else:
                self.logger.error("Failed to update scripts component")
                return False
                
        except Exception as e:
            self.logger.error(f"Failed to update scripts component: {e}")
            return False
    
    def verify(self) -> Tuple[bool, List[str]]:
        """
        Verify scripts component installation
        
        Returns:
            Tuple of (is_valid, list_of_errors)
        """
        errors = []
        
        # Check scripts directory exists
        scripts_dir = self.install_dir / "scripts"
        if not scripts_dir.exists():
            errors.append(f"Scripts directory missing: {scripts_dir}")
            return False, errors
        
        # Get expected scripts from source
        source_dir = self._get_source_directory()
        expected_scripts = {f.name for f in source_dir.glob("*.sh")}
        
        if not expected_scripts:
            # No scripts expected, so valid
            return True, []
        
        # Check each expected script exists and is executable
        for script_name in expected_scripts:
            script_path = scripts_dir / script_name
            if not script_path.exists():
                errors.append(f"Missing script: {script_name}")
            elif not os.access(script_path, os.X_OK):
                errors.append(f"Script not executable: {script_name}")
        
        # Check for unexpected scripts
        actual_scripts = {f.name for f in scripts_dir.glob("*.sh")}
        unexpected = actual_scripts - expected_scripts
        if unexpected:
            errors.append(f"Unexpected scripts found: {', '.join(unexpected)}")
        
        return len(errors) == 0, errors
    
    def _get_source_directory(self) -> Path:
        """Get source directory for script files"""
        # Assume we're in SuperClaude/setup/components/scripts.py
        # and script files are in SuperClaude/SuperClaude/Scripts/
        project_root = Path(__file__).parent.parent.parent
        return project_root / "SuperClaude" / "Scripts"
    
    def get_size_estimate(self) -> int:
        """
        Get estimated installation size in bytes
        
        Returns:
            Estimated size in bytes
        """
        source_dir = self._get_source_directory()
        if not source_dir.exists():
            return 0
            
        total_size = 0
        for script_file in source_dir.glob("*.sh"):
            try:
                total_size += script_file.stat().st_size
            except:
                pass
                
        return total_size