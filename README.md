# RecordViewer Application

**RecordViewer** is a custom Salesforce application that enables users to search and view records across multiple standard objects (Account, Contact, Opportunity) via a Lightning Web Component (LWC) interface. The interface supports both direct interaction and deep linking via URL query parameters for quick access to specific data.

---

## 📦 Components

### 💻 Application & FlexiPage
- **Custom Application**: `RecordViewer`
- **FlexiPage**: `Records_Quick_View`
  - Hosts the main Lightning Web Component `recordList`

### ⚙️ Apex Classes
- **RecordController**: Apex controller exposed to the LWC
  - `getRecordsByName(String objectName, String searchTerm)`
- **RecordSelector**: Helper class
  - `getFields(String objectName, String fieldSetName)`
  - `queryRecords(String objectName, String searchTerm, List<String> fields)`
- **UserAccessController**: Handles record-level access checks
  - `getRecordsWithAccess(List<SObject>)`

### 🔐 Permission Set
- **RecordViewerPermissions**: Grants access to the Apex classes and fields used by the application

---

## ⚡ Lightning Web Component: `recordList`

### 🔧 Features
- **Dropdown** for selecting the object type (`Account`, `Contact`, `Opportunity`)
- **Search input** to enter the name (partial match supported via `LIKE` operator)
- **Submit button** to fetch matching records
- **Record display table** with:
  - Lock icon for records without access
  - Expandable row panel on the right for accessible records with detailed view

### 🔗 URL Query Parameters
The component supports deep linking by accepting the following URL query parameters:
- `object`: Object API name (e.g., `Account`)
- `name`: Name text to search (e.g., `Acme`)

**Example Usage:**
https://<your-salesforce-instance>/lightning/n/RecordViewer?c__objectname=Account&c__name=Acme

---

## 🔍 Record Fetch Logic

1. **User interaction or query parameters** trigger the `getRecordsByName` method in `RecordController`.
2. `RecordController`:
   - Calls `getFields` from `RecordSelector` using the appropriate FieldSet (e.g., `Account.BasicFields`)
   - Calls `queryRecords` with a `LIKE` search on the `Name` field
   - Passes results to `UserAccessController.getRecordsWithAccess` to determine field-level visibility
3. **Result Rendering**:
   - Accessible records show full field data
   - Inaccessible records display only `Name` with a lock icon

---

## 📁 FieldSets Used
- `Account.BasicFields`
- `Contact.BasicFields`
- `Opportunity.BasicFields`

These field sets define which fields are shown for each object when records are accessible.

---

## 🔒 Access Control

The `UserAccessController` class ensures the logged-in user has access to view specific records. Only the `Name` field is shown for inaccessible records, accompanied by a lock icon for clarity.

---

## 🛠️ Setup Instructions

1. Assign the `RecordViewerPermissions` permission set to users.
2. Ensure field sets (`BasicFields`) exist and are populated for Account, Contact, and Opportunity.
3. Deploy the application and add the `Records_Quick_View` FlexiPage to the navigation or utility bar as needed.

---

## 📬 Contact

For support or enhancements, please reach out to sushil.kalsekar@gmail.com .
