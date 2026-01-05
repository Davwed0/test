"""Tax category classifier for HK tax deductions and income."""

from typing import List, Dict, Tuple
from pathlib import Path
import re
from src.config import Config
from src.markdown_parser import MarkdownParser


class TaxCategoryClassifier:
    """Classifier for Hong Kong tax categories."""
    
    def __init__(self, categories_file: Path = None):
        """
        Initialize the tax category classifier.
        
        Args:
            categories_file: Path to the tax categories markdown file
        """
        self.categories_file = categories_file or Config.TAX_CATEGORIES_FILE
        self.parser = MarkdownParser()
        self.categories = self._load_categories()
    
    def _load_categories(self) -> Dict[str, Dict[str, List[str]]]:
        """Load and parse tax categories from markdown file."""
        if not self.categories_file.exists():
            print(f"Warning: Categories file not found: {self.categories_file}")
            return {"deductions": {}, "income": {}}
        
        parsed = self.parser.parse_file(self.categories_file)
        sections = parsed["sections"]
        
        categories = {
            "deductions": {},
            "income": {}
        }
        
        current_type = None
        
        for section in sections:
            heading = section["heading"]
            content = section["content"]
            level = section["level"]
            
            # Level 1: Main heading (Hong Kong Tax Categories)
            if level == 1:
                continue
            
            # Level 2: Tax Deductions or Income Categories
            if level == 2:
                if "deduction" in heading.lower():
                    current_type = "deductions"
                elif "income" in heading.lower():
                    current_type = "income"
            
            # Level 3: Specific category
            elif level == 3 and current_type:
                current_category = heading
                keywords = self._extract_keywords(heading + " " + content)
                categories[current_type][current_category] = keywords
        
        return categories
    
    def _extract_keywords(self, content: str) -> List[str]:
        """Extract keywords from category description."""
        # Convert to lowercase and split into words
        words = re.findall(r'\b[a-z]+\b', content.lower())
        
        # Filter out common words
        stop_words = {
            'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for',
            'of', 'with', 'by', 'from', 'up', 'about', 'into', 'through', 'during',
            'before', 'after', 'above', 'below', 'between', 'under', 'is', 'are',
            'was', 'were', 'be', 'been', 'being', 'have', 'has', 'had', 'do', 'does',
            'did', 'will', 'would', 'should', 'could', 'may', 'might', 'must', 'can'
        }
        
        keywords = [word for word in words if word not in stop_words and len(word) > 3]
        
        # Remove duplicates while preserving order
        seen = set()
        unique_keywords = []
        for keyword in keywords:
            if keyword not in seen:
                seen.add(keyword)
                unique_keywords.append(keyword)
        
        return unique_keywords
    
    def classify_document(self, content: str, key_values: Dict[str, str]) -> Dict[str, List[Tuple[str, float]]]:
        """
        Classify document content into tax categories.
        
        Args:
            content: Document content
            key_values: Extracted key-value pairs
            
        Returns:
            Dictionary with deduction and income classifications
        """
        content_lower = content.lower()
        combined_text = content_lower + " " + " ".join(key_values.values()).lower()
        
        classifications = {
            "deductions": [],
            "income": []
        }
        
        # Check each category
        for cat_type in ["deductions", "income"]:
            for category_name, keywords in self.categories[cat_type].items():
                score = self._calculate_category_score(combined_text, keywords)
                if score > 0:
                    classifications[cat_type].append((category_name, score))
        
        # Sort by score
        classifications["deductions"].sort(key=lambda x: x[1], reverse=True)
        classifications["income"].sort(key=lambda x: x[1], reverse=True)
        
        return classifications
    
    def _calculate_category_score(self, text: str, keywords: List[str]) -> float:
        """
        Calculate how well text matches a category based on keywords.
        
        Args:
            text: Text to analyze
            keywords: Category keywords
            
        Returns:
            Score (0-1) indicating match strength
        """
        if not keywords:
            return 0.0
        
        matches = sum(1 for keyword in keywords if keyword in text)
        score = matches / len(keywords)
        
        return score
    
    def get_category_descriptions(self) -> Dict[str, Dict[str, str]]:
        """Get descriptions of all categories."""
        parsed = self.parser.parse_file(self.categories_file)
        sections = parsed["sections"]
        
        descriptions = {
            "deductions": {},
            "income": {}
        }
        
        current_type = None
        
        for section in sections:
            heading = section["heading"]
            content = section["content"].strip()
            level = section["level"]
            
            if level == 2:
                if "deduction" in heading.lower():
                    current_type = "deductions"
                elif "income" in heading.lower():
                    current_type = "income"
            elif level == 3 and current_type:
                # Get first line as description
                first_line = content.split('\n')[0] if content else ""
                descriptions[current_type][heading] = first_line
        
        return descriptions
