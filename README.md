# Quarto Notebooks and Slides Project

This project demonstrates the use of [Quarto](https://quarto.org) for creating interactive notebooks and presentation slides.

## Overview

Quarto is an open-source scientific and technical publishing system that allows you to create dynamic content with Python, R, Julia, and Observable. This project includes:

- **Interactive Notebooks**: Computational notebooks with executable Python code
- **Presentation Slides**: Professional RevealJS slides for presentations
- **Website**: A rendered website containing all content

## Project Structure

```
.
├── _quarto.yml              # Quarto project configuration
├── index.qmd                # Home page
├── styles.css               # Custom CSS styles
├── notebooks/
│   ├── data-analysis.qmd    # Data analysis notebook
│   └── python-tutorial.qmd  # Python tutorial notebook
└── slides/
    └── presentation.qmd     # RevealJS presentation
```

## Contents

### Notebooks

1. **Data Analysis** (`notebooks/data-analysis.qmd`)
   - Data generation with NumPy
   - Data manipulation with Pandas
   - Visualization with Matplotlib
   - Statistical analysis

2. **Python Tutorial** (`notebooks/python-tutorial.qmd`)
   - Variables and data types
   - Control structures
   - Functions and comprehensions
   - Dictionaries and string operations

### Slides

**Introduction to Quarto** (`slides/presentation.qmd`)
- Overview of Quarto features
- Code execution examples
- Data visualization
- Output formats
- Best practices

## Requirements

- Quarto (>= 1.4)
- Python 3
- Required Python packages:
  - jupyter
  - numpy
  - pandas
  - matplotlib

## Installation

### Install Quarto

**Linux:**
```bash
wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.551/quarto-1.4.551-linux-amd64.deb
sudo dpkg -i quarto-1.4.551-linux-amd64.deb
```

**macOS:**
```bash
brew install quarto
```

**Windows:**
Download the installer from [Quarto releases](https://github.com/quarto-dev/quarto-cli/releases)

### Install Python Dependencies

```bash
pip install jupyter numpy pandas matplotlib
```

## Usage

### Render the Entire Project

To render all documents and generate the website:

```bash
quarto render
```

The output will be created in the `_site` directory.

### Preview with Live Reload

To preview the project with automatic reloading on changes:

```bash
quarto preview
```

This will start a local server (typically at http://localhost:4200) and open your browser.

### Render Individual Files

To render a specific document:

```bash
# Render a notebook
quarto render notebooks/data-analysis.qmd

# Render the presentation
quarto render slides/presentation.qmd
```

### Export to Different Formats

Quarto supports multiple output formats:

```bash
# Export notebook to PDF
quarto render notebooks/data-analysis.qmd --to pdf

# Export slides to PowerPoint
quarto render slides/presentation.qmd --to pptx

# Export to Word document
quarto render index.qmd --to docx
```

## Viewing the Output

After rendering, you can:

1. **View the Website**: Open `_site/index.html` in your browser
2. **View Notebooks**: Open `_site/notebooks/data-analysis.html` or `_site/notebooks/python-tutorial.html`
3. **View Slides**: Open `_site/slides/presentation.html` for the RevealJS presentation

### Presentation Controls

When viewing the slides:
- Use arrow keys to navigate
- Press `S` for speaker notes
- Press `F` for fullscreen
- Press `O` for overview mode
- Press `?` for help

## Development

### Adding New Notebooks

1. Create a new `.qmd` file in the `notebooks/` directory
2. Add frontmatter with title and format
3. Write your content with code blocks
4. Update `_quarto.yml` to add it to the navigation
5. Render the project

### Adding New Slides

1. Create a new `.qmd` file in the `slides/` directory
2. Set `format: revealjs` in the frontmatter
3. Use `##` for slide breaks
4. Add code blocks as needed
5. Render the project

### Customization

- **Styles**: Edit `styles.css` to customize appearance
- **Theme**: Modify the `theme` setting in `_quarto.yml` or slide frontmatter
- **Layout**: Adjust the website structure in `_quarto.yml`

## Publishing

You can publish the rendered site to various platforms:

### GitHub Pages

```bash
quarto publish gh-pages
```

### Netlify

```bash
quarto publish netlify
```

### Quarto Pub

```bash
quarto publish quarto-pub
```

## Resources

- [Quarto Documentation](https://quarto.org/docs/guide/)
- [Quarto Gallery](https://quarto.org/docs/gallery/)
- [Quarto GitHub](https://github.com/quarto-dev/quarto-cli)
- [RevealJS Documentation](https://revealjs.com/)

## License

This project is open source and available for educational purposes.