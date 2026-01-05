"""Markdown parser for extracting content by headings."""

import re
from typing import List, Dict, Tuple
from pathlib import Path


class MarkdownParser:
    """Parser for markdown files that splits content by headings."""
    
    def __init__(self):
        self.heading_pattern = re.compile(r'^(#{1,6})\s+(.+)$', re.MULTILINE)
    
    def parse_file(self, file_path: Path) -> Dict[str, any]:
        """
        Parse a markdown file and extract structured content.
        
        Args:
            file_path: Path to the markdown file
            
        Returns:
            Dictionary containing filename, sections, and metadata
        """
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        return self.parse_content(content, str(file_path))
    
    def parse_content(self, content: str, source: str = "") -> Dict[str, any]:
        """
        Parse markdown content and split by headings.
        
        Args:
            content: Markdown content as string
            source: Source identifier (e.g., filename)
            
        Returns:
            Dictionary with parsed sections
        """
        sections = self._split_by_headings(content)
        
        # Extract key-value pairs from content
        key_values = self._extract_key_values(content)
        
        return {
            "source": source,
            "sections": sections,
            "key_values": key_values,
            "full_content": content
        }
    
    def _split_by_headings(self, content: str) -> List[Dict[str, str]]:
        """
        Split content by markdown headings.
        
        Returns:
            List of sections with heading and content
        """
        sections = []
        lines = content.split('\n')
        current_section = {"heading": "", "level": 0, "content": ""}
        
        for line in lines:
            heading_match = self.heading_pattern.match(line)
            
            if heading_match:
                # Save previous section if it has content
                if current_section["content"].strip():
                    sections.append(current_section.copy())
                
                # Start new section
                level = len(heading_match.group(1))
                heading_text = heading_match.group(2).strip()
                current_section = {
                    "heading": heading_text,
                    "level": level,
                    "content": ""
                }
            else:
                current_section["content"] += line + "\n"
        
        # Add last section
        if current_section["content"].strip():
            sections.append(current_section)
        
        return sections
    
    def _extract_key_values(self, content: str) -> Dict[str, str]:
        """
        Extract key-value pairs from markdown content.
        Looks for patterns like "**Key**: Value" or "- **Key**: Value"
        
        Returns:
            Dictionary of extracted key-value pairs
        """
        key_values = {}
        
        # Pattern for bold key-value pairs: **Key**: Value
        bold_kv_pattern = re.compile(r'\*\*([^*]+)\*\*:\s*(.+?)(?=\n|$)')
        
        for match in bold_kv_pattern.finditer(content):
            key = match.group(1).strip()
            value = match.group(2).strip()
            key_values[key] = value
        
        return key_values
    
    def generate_summary(self, parsed_doc: Dict[str, any]) -> str:
        """
        Generate a summary of the document based on its structure.
        
        Args:
            parsed_doc: Parsed document dictionary
            
        Returns:
            Summary string
        """
        sections = parsed_doc.get("sections", [])
        key_values = parsed_doc.get("key_values", {})
        
        if not sections:
            return "Empty document"
        
        # Get main heading (first section)
        main_heading = sections[0]["heading"] if sections else "Document"
        
        # Count sections
        section_count = len(sections)
        
        # Get important keys
        important_keys = []
        for key in ["Invoice Number", "Account Holder", "Property Address", 
                    "Date", "Total Amount Due", "Monthly Rent"]:
            if key in key_values:
                important_keys.append(f"{key}: {key_values[key]}")
        
        summary_parts = [main_heading]
        if important_keys:
            summary_parts.append(" | ".join(important_keys[:3]))
        summary_parts.append(f"{section_count} sections")
        
        return " - ".join(summary_parts)
