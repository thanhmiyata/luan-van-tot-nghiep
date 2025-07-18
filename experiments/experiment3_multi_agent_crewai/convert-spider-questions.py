#!/usr/bin/env python3
"""
Script to extract db_id and question fields from train_spider.json
and save them to questions.json as an array of JSON objects.
"""

import json
import os

def main():
    # Define file paths
    input_file = "train_spider.json"
    output_file = "questions.json"
    
    # Check if input file exists
    if not os.path.exists(input_file):
        print(f"Error: Input file '{input_file}' not found.")
        return
    
    try:
        # Read the input file
        print(f"Reading data from {input_file}...")
        with open(input_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Extract db_id and question fields
        print("Extracting db_id and question fields...")
        questions = []
        for item in data:
            questions.append({
                "db_id": item["db_id"],
                "question": item["question"]
            })
        
        # Write to output file
        print(f"Writing {len(questions)} questions to {output_file}...")
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(questions, f, ensure_ascii=False, indent=4)
        
        print(f"Successfully created {output_file} with {len(questions)} questions.")
    
    except json.JSONDecodeError:
        print(f"Error: {input_file} is not a valid JSON file.")
    except KeyError as e:
        print(f"Error: Missing required field {e} in the input data.")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()