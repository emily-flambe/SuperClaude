"""
Hooks component for Claude Code hooks integration (future-ready)
"""

from typing import Dict, List, Tuple, Optional, Any
from pathlib import Path

from ..base.component import Component


class HooksComponent(Component):
    """Claude Code hooks integration component"""
    
    def __init__(self, install_dir: Optional[Path] = None):
        """Initialize hooks component"""
        super().__init__(install_dir, Path("hooks"))
        
        # Define hook files to install
        self.hook_files = [
            "anti_sycophant.py"  # Anti-sycophantic behavior hook
        ]
        
        # Set component_files for base class
        self.component_files = self.hook_files
    
    def get_metadata(self) -> Dict[str, str]:
        """Get component metadata"""
        return {
            "name": "hooks",
            "version": "3.0.0",
            "description": "Claude Code hooks for enhanced behavior and anti-sycophantic responses",
            "category": "integration"
        }
    def get_metadata_modifications(self) -> Dict[str, Any]:
        # Build hooks configuration based on available files
        hook_config = {}
        for filename in self.hook_files:
            hook_path = self.install_component_subdir / filename
            if hook_path.exists():
                hook_name = filename.replace('.py', '')
                hook_config[hook_name] = [str(hook_path)]
        
        metadata_mods = {
            "components": {
                "hooks": {
                    "version": "3.0.0",
                    "installed": True,
                    "files_count": len(hook_config)
                }
            }
        }
        
        # Only add hooks configuration if we have actual hook files
        if hook_config:
            metadata_mods["hooks"] = {
                "enabled": True,
                **hook_config
            }

        
        return metadata_mods

    def _install(self, config: Dict[str, Any]) -> bool:
        """Install hooks component"""
        self.logger.info("Installing SuperClaude hooks component...")

        # Check if source directory exists
        source_dir = self._get_source_dir()

        if not source_dir.exists():
            self.logger.info("Hooks are not yet implemented - installing placeholder component")
            
            # Create placeholder hooks directory
            if not self.file_manager.ensure_directory(self.install_component_subdir):
                self.logger.error(f"Could not create hooks directory: {self.install_component_subdir}")
                return False

            # Create placeholder file
            placeholder_content = '''"""
SuperClaude Hooks

This directory contains Claude Code hooks for enhanced behavior.

Available hooks:
- anti_sycophant: Prevents sycophantic responses and enforces objective, technical communication

For more information, see SuperClaude documentation.
"""

# This file is a placeholder when no actual hooks are installed
'''
            
            placeholder_path = self.install_component_subdir / "PLACEHOLDER.py"
            try:
                with open(placeholder_path, 'w') as f:
                    f.write(placeholder_content)
                self.logger.debug("Created hooks placeholder file")
            except Exception as e:
                self.logger.warning(f"Could not create placeholder file: {e}")
            
            # Update settings with placeholder registration
            try:
                metadata_mods = {
                    "components": {
                        "hooks": {
                            "version": "3.0.0",
                            "installed": True,
                            "status": "placeholder",
                            "files_count": 0
                        }
                    }
                }
                self.settings_manager.update_metadata(metadata_mods)
                self.logger.info("Updated metadata with hooks component registration")
            except Exception as e:
                self.logger.error(f"Failed to update metadata for hooks component: {e}")
                return False
            
            self.logger.success("Hooks component installed successfully (placeholder)")
            return True

        # If hooks source directory exists, install actual hooks
        self.logger.info("Installing actual hook files...")

        # Validate installation
        success, errors = self.validate_prerequisites(Path("hooks"))
        if not success:
            for error in errors:
                self.logger.error(error)
            return False

        # Get files to install
        files_to_install = self.get_files_to_install()

        if not files_to_install:
            self.logger.warning("No hook files found to install")
            return False

        # Copy hook files
        success_count = 0
        for source, target in files_to_install:
            self.logger.debug(f"Copying {source.name} to {target}")
            
            if self.file_manager.copy_file(source, target):
                success_count += 1
                self.logger.debug(f"Successfully copied {source.name}")
            else:
                self.logger.error(f"Failed to copy {source.name}")

        if success_count != len(files_to_install):
            self.logger.error(f"Only {success_count}/{len(files_to_install)} hook files copied successfully")
            return False

        self.logger.success(f"Hooks component installed successfully ({success_count} hook files)")

        return self._post_install()

    def _post_install(self):
        # Update metadata
        try:
            metadata_mods = self.get_metadata_modifications()
            self.settings_manager.update_metadata(metadata_mods)
            self.logger.info("Updated metadata with hooks configuration")

            # Add hook registration to metadata
            self.settings_manager.add_component_registration("hooks", {
                "version": "3.0.0",
                "category": "integration",
                "files_count": len(self.hook_files)
            })

            # Configure anti_sycophant hook in settings.json if it was installed
            anti_sycophant_path = self.install_component_subdir / "anti_sycophant.py"
            if anti_sycophant_path.exists():
                self.settings_manager.add_stop_hook(str(anti_sycophant_path), timeout=5)
                self.logger.info("Configured anti_sycophant hook in settings.json")

            self.logger.info("Updated metadata with hooks component registration")
        except Exception as e:
            self.logger.error(f"Failed to update metadata: {e}")
            return False

        return True
    
    def uninstall(self) -> bool:
        """Uninstall hooks component"""
        try:
            self.logger.info("Uninstalling SuperClaude hooks component...")
            
            # Remove hook files and placeholder
            removed_count = 0
            
            # Remove actual hook files
            for filename in self.hook_files:
                file_path = self.install_component_subdir / filename
                if self.file_manager.remove_file(file_path):
                    removed_count += 1
                    self.logger.debug(f"Removed {filename}")
            
            # Remove placeholder file
            placeholder_path = self.install_component_subdir / "PLACEHOLDER.py"
            if self.file_manager.remove_file(placeholder_path):
                removed_count += 1
                self.logger.debug("Removed hooks placeholder")
            
            # Remove hooks directory if empty
            try:
                if self.install_component_subdir.exists():
                    remaining_files = list(self.install_component_subdir.iterdir())
                    if not remaining_files:
                        self.install_component_subdir.rmdir()
                        self.logger.debug("Removed empty hooks directory")
            except Exception as e:
                self.logger.warning(f"Could not remove hooks directory: {e}")
            
            # Update settings.json to remove hooks component and configuration
            try:
                if self.settings_manager.is_component_installed("hooks"):
                    self.settings_manager.remove_component_registration("hooks")
                    self.logger.info("Removed hooks component from metadata")
                    
                # Remove hooks configuration from settings.json
                settings = self.settings_manager.load_settings()
                hooks_removed = False
                
                if "hooks" in settings and "Stop" in settings["hooks"]:
                    # Filter out our anti_sycophant hook from Stop hooks
                    stop_hooks = settings["hooks"]["Stop"]
                    filtered_hooks = []
                    
                    for hook_config in stop_hooks:
                        if "hooks" in hook_config:
                            filtered_hook_list = []
                            for hook in hook_config["hooks"]:
                                if hook.get("command", "").endswith("anti_sycophant.py"):
                                    hooks_removed = True
                                    continue
                                filtered_hook_list.append(hook)
                            
                            if filtered_hook_list:
                                hook_config["hooks"] = filtered_hook_list
                                filtered_hooks.append(hook_config)
                    
                    if filtered_hooks:
                        settings["hooks"]["Stop"] = filtered_hooks
                    else:
                        # Remove Stop key if no hooks left
                        del settings["hooks"]["Stop"]
                        
                        # Remove hooks section entirely if empty
                        if not settings["hooks"]:
                            del settings["hooks"]
                    
                    if hooks_removed:
                        self.settings_manager.save_settings(settings)
                        self.logger.info("Removed anti_sycophant hook from settings.json")
                        
            except Exception as e:
                self.logger.warning(f"Could not update settings.json: {e}")
            
            self.logger.success(f"Hooks component uninstalled ({removed_count} files removed)")
            return True
            
        except Exception as e:
            self.logger.exception(f"Unexpected error during hooks uninstallation: {e}")
            return False
    
    def get_dependencies(self) -> List[str]:
        """Get dependencies"""
        return ["core"]
    
    def update(self, config: Dict[str, Any]) -> bool:
        """Update hooks component"""
        try:
            self.logger.info("Updating SuperClaude hooks component...")
            
            # Check current version
            current_version = self.settings_manager.get_component_version("hooks")
            target_version = self.get_metadata()["version"]
            
            if current_version == target_version:
                self.logger.info(f"Hooks component already at version {target_version}")
                return True
            
            self.logger.info(f"Updating hooks component from {current_version} to {target_version}")
            
            # Create backup of existing hook files
            backup_files = []
            
            if self.install_component_subdir.exists():
                for filename in self.hook_files + ["PLACEHOLDER.py"]:
                    file_path = self.install_component_subdir / filename
                    if file_path.exists():
                        backup_path = self.file_manager.backup_file(file_path)
                        if backup_path:
                            backup_files.append(backup_path)
                            self.logger.debug(f"Backed up {filename}")
            
            # Perform installation (overwrites existing files)
            success = self.install(config)
            
            if success:
                # Remove backup files on successful update
                for backup_path in backup_files:
                    try:
                        backup_path.unlink()
                    except Exception:
                        pass  # Ignore cleanup errors
                
                self.logger.success(f"Hooks component updated to version {target_version}")
            else:
                # Restore from backup on failure
                self.logger.warning("Update failed, restoring from backup...")
                for backup_path in backup_files:
                    try:
                        original_path = backup_path.with_suffix('')
                        backup_path.rename(original_path)
                        self.logger.debug(f"Restored {original_path.name}")
                    except Exception as e:
                        self.logger.error(f"Could not restore {backup_path}: {e}")
            
            return success
            
        except Exception as e:
            self.logger.exception(f"Unexpected error during hooks update: {e}")
            return False
    
    def validate_installation(self) -> Tuple[bool, List[str]]:
        """Validate hooks component installation"""
        errors = []
        
        # Check if hooks directory exists
        if not self.install_component_subdir.exists():
            errors.append("Hooks directory not found")
            return False, errors
        
        # Check settings.json registration
        if not self.settings_manager.is_component_installed("hooks"):
            errors.append("Hooks component not registered in settings.json")
        else:
            # Check version matches
            installed_version = self.settings_manager.get_component_version("hooks")
            expected_version = self.get_metadata()["version"]
            if installed_version != expected_version:
                errors.append(f"Version mismatch: installed {installed_version}, expected {expected_version}")
        
        # Check if we have either actual hooks or placeholder
        has_placeholder = (self.install_component_subdir / "PLACEHOLDER.py").exists()
        has_actual_hooks = any((self.install_component_subdir / filename).exists() for filename in self.hook_files)
        
        if not has_placeholder and not has_actual_hooks:
            errors.append("No hook files or placeholder found")
        
        return len(errors) == 0, errors
    
    def _get_source_dir(self) -> Path:
        """Get source directory for hook files"""
        # Assume we're in SuperClaude/setup/components/hooks.py
        # and hook files are in SuperClaude/SuperClaude/Hooks/
        project_root = Path(__file__).parent.parent.parent
        return project_root / "SuperClaude" / "Hooks"
    
    def get_size_estimate(self) -> int:
        """Get estimated installation size"""
        # Estimate based on placeholder or actual files
        source_dir = self._get_source_dir()
        total_size = 0
        
        if source_dir.exists():
            for filename in self.hook_files:
                file_path = source_dir / filename
                if file_path.exists():
                    total_size += file_path.stat().st_size
        
        # Add placeholder overhead or minimum size
        total_size = max(total_size, 10240)  # At least 10KB
        
        return total_size
    
    def get_installation_summary(self) -> Dict[str, Any]:
        """Get installation summary"""
        source_dir = self._get_source_dir()
        status = "placeholder" if not source_dir.exists() else "implemented"
        
        return {
            "component": self.get_metadata()["name"],
            "version": self.get_metadata()["version"],
            "status": status,
            "hook_files": self.hook_files if source_dir.exists() else ["PLACEHOLDER.py"],
            "estimated_size": self.get_size_estimate(),
            "install_directory": str(self.install_dir / "hooks"),
            "dependencies": self.get_dependencies()
        }
