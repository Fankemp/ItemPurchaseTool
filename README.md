# 🛒 Salesforce Item Purchase Tool

A custom Salesforce application designed to manage purchases and items efficiently. This project demonstrates best practices in Apex development, including the Handler Pattern, Bulkification, and LWC integration.

## 🚀 Features

- **Automated Calculations**: Real-time calculation of `GrandTotal__c` and `TotalItems__c` on the Purchase object via Apex Triggers.
- **Bulkified Logic**: Efficient data processing using Maps and Sets to stay within Salesforce Governor Limits.
- **Data Integrity**: Robust handling of Insert, Update, Delete, and Undelete scenarios for Purchase Lines.
- **Custom UI (In Progress)**: A modern Lightning Web Component (LWC) for a seamless shopping experience.

## 🏗️ Technical Architecture

### Data Model
- **Purchase__c**: The parent object storing total amounts and status.
- **PurchaseLine__c**: Junction-like object connecting Purchases to Items with quantity and unit cost.
- **Item__c**: Product catalog with pricing information.

### Backend Logic
- `PurchaseLineTrigger`: A lightweight trigger acting as a router.
- `PurchaseLineTriggerHandler`: The "brain" of the operation, using optimized SOQL and Map-based logic for calculations.

## 🛠️ Installation

1. Clone the repository:
   ```bash
   git clone [YOUR_REPOSITORY_LINK]