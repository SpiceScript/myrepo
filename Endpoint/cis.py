import pandas as pd
from bs4 import BeautifulSoup
import tkinter as tk
from tkinter import filedialog
import logging
import os

# Configure logging
logging.basicConfig(level=logging.INFO)

# Function to open a file dialog and select an HTML file
def select_file():
    root = tk.Tk()
    root.withdraw()  # Hide the root window
    file_path = filedialog.askopenfilename(
        title="Select HTML File",
        filetypes=[("HTML files", "*.html")]
    )
    return file_path

# Function to extract rule data from an HTML element
def extract_rule_data(element, current_section, current_group_title):
    rule_data = {
        'Section': current_section,
        'Group Title': current_group_title,
        'Rule Title': '',
        'Outcome': '',
        'Description': '',
        'Rationale': '',
        'Fixtext': '',
        'Safeguard': '',
        'Implementation Group': ''
    }

    # Extract rule title
    rule_title = element.find('h3', class_='ruleTitle')
    if rule_title:
        rule_data['Rule Title'] = rule_title.text.strip()

    # Extract outcome (pass/fail)
    outcome = element.find('span', class_='outcome')
    if outcome:
        rule_data['Outcome'] = outcome.text.strip()

    # Extract description
    description_div = element.find('div', class_='description')
    if description_div:
        description_text = description_div.find('p')
        if description_text:
            rule_data['Description'] = description_text.text.strip()

    # Extract rationale
    rationale_div = element.find('div', class_='rationale')
    if rationale_div:
        rationale_texts = [p.text.strip() for p in rationale_div.find_all('p')]
        rule_data['Rationale'] = " ".join(rationale_texts)

    # Extract fixtext (safeguards)
    fixtext_div = element.find('div', class_='fixtext')
    if fixtext_div:
        fixtext_paragraphs = [p.text.strip() for p in fixtext_div.find_all('p')]
        rule_data['Fixtext'] = " ".join(fixtext_paragraphs)

    # Extract Safeguard and Implementation Group from tables
    for table in element.find_all('table', class_='enum'):
        for row in table.find_all('tr'):
            cells = row.find_all('td')
            if len(cells) == 2:  # Ensure the row has two columns
                header, value = cells[0].text.strip(), cells[1].text.strip()
                if "Safeguard" in header:
                    rule_data['Safeguard'] = value
                elif "Implementation Group" in header:
                    rule_data['Implementation Group'] = value

    return rule_data

# Main execution flow
try:
    html_file_path = select_file()
    
    if not html_file_path:
        raise ValueError("No file selected.")
    
    logging.info("Loading HTML file: %s", html_file_path)
    
    with open(html_file_path, 'r', encoding='utf-8') as file:
        soup = BeautifulSoup(file, 'html.parser')

    data = []
    current_section = None
    current_group_title = None

    logging.info("Starting data extraction...")
    
    for element in soup.find_all(['div', 'h2']):
        # Check if the element is a section title or group title
        if element.get('class') and 'sectionTitle' in element.get('class', []):
            current_section = element.text.strip()  # Update current section

        elif element.get('class') and 'ruleGroupTitle' in element.get('class', []):
            current_group_title = element.text.strip()  # Update current group title

        elif element.get('class') and 'Rule' in element.get('class', []):
            rule_data = extract_rule_data(element, current_section, current_group_title)
            data.append(rule_data)

            # Append the main section title as well for clarity in output
            if current_section and not any(d['Section'] == current_section for d in data):
                data.append({
                    'Section': current_section,
                    'Group Title': None,
                    'Rule Title': '',
                    'Outcome': '',
                    'Description': '',
                    'Rationale': '',
                    'Fixtext': '',
                    'Safeguard': '',
                    'Implementation Group': ''
                })

    # Convert the extracted data into a DataFrame
    df = pd.DataFrame(data)

    # Generate output file name based on input filename or use a default name
    output_file_name = os.path.splitext(os.path.basename(html_file_path))[0] + '_Extracted_Data.xlsx'
    
    df.to_excel(output_file_name, index=False)
    
    logging.info("Data successfully saved to %s", output_file_name)

except Exception as e:
    logging.error("An error occurred: %s", e)
