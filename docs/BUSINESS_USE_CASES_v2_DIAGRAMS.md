# Business Use Cases: Sales to Product Group Interactions
## ElectroRent AI Product Advisor MVP

**Project**: ElectroRent AI Product Advisor MVP  
**Document Version**: 2.0 (Enhanced with Discovery Calls - Mermaid Diagrams)  
**Date**: November 2025  
**Stakeholders**: Sales Team, Product Group, Management

---

## Executive Summary

This document outlines real-world business use cases derived from discovery calls with the ElectroRent Product Group and Sales team. These scenarios represent the core interactions between Sales and Product Group that the AI Product Advisor solution will automate and enhance. The system reduces escalations to Product Group by 70-80% while enabling Sales to serve customers faster with accurate, data-driven recommendations.

---

## Understanding the Business Context

### Current Process Flow

```mermaid
graph TD
    A["Customer Inquiry"] --> B["Sales Rep<br/>Doesn't Know Answer"]
    B --> C["Sales Contacts<br/>Product Group"]
    C --> D["Product Group<br/>Manual Research"]
    D --> E["Check Perfect<br/>Inventory System"]
    D --> F["Review Specifications<br/>and Data Sheets"]
    D --> G["Look up D365<br/>European Warehouse"]
    E --> H["Product Group<br/>Responds"]
    F --> H
    G --> H
    H --> I["Sales Communicates<br/>Back to Customer"]
    I --> J["Follow-up Questions?"]
    J -->|Yes| C
    J -->|No| K["Deal Closed<br/>or Lost"]
    
    style A fill:#ff6b6b
    style K fill:#51cf66
    style C fill:#ffd43b
    style H fill:#ffd43b
```

**Current State Characteristics:**
- Response Time: 30 minutes to 4 hours
- Multiple Escalations: Sales to PG to Warehouse to Supplier
- Information Silos: Data scattered across Perfect, D365, Salesforce
- Customer Wait: Competitor calls during delay
- Resource Cost: Senior staff research for routine queries

---

### Desired Future State with AI Product Advisor

```mermaid
graph TD
    A["Customer Inquiry"] --> B["Sales Rep Uses<br/>AI Product Advisor"]
    B --> C["System Provides<br/>Instant Response"]
    C --> D["Live Inventory Data"]
    C --> E["Real-time Pricing"]
    C --> F["Alternative Options"]
    C --> G["Technical Specs"]
    D --> H["Sales Gives Immediate<br/>Answer to Customer"]
    E --> H
    F --> H
    G --> H
    H --> I["Complex or Unclear?"]
    I -->|No| J["Deal Closed"]
    I -->|Yes| K["Escalate to PG<br/>with AI Analysis"]
    K --> L["PG Makes<br/>Quick Decision"]
    L --> J
    
    style A fill:#4c6ef5
    style H fill:#51cf66
    style J fill:#51cf66
    style B fill:#15aabf
```

**Future State Characteristics:**
- Response Time: Seconds to minutes
- Single Interface: One chatbot for all queries
- Integrated Data: Real-time access to all systems
- Customer Satisfaction: Immediate answers
- Resource Efficiency: PG focuses only on complex decisions

---

## Core Use Cases from Discovery Calls

### Product Selection Scenario Breakdown

During discovery calls, Product Group identified three core ways customers express their needs:

```mermaid
graph TD
    A["Customer Need"] --> B{How Expressed?}
    B -->|Type 1| C["Specific Equipment<br/>Part Number Known"]
    B -->|Type 2| D["Application/Test Type<br/>Describe What to Test"]
    B -->|Type 3| E["Problem Description<br/>Vague/Unclear Need"]
    
    C --> C1["AI Resolution: 90%"]
    C --> C2["Escalation: 10%"]
    
    D --> D1["AI Resolution: 50-60%"]
    D --> D2["Escalation: 40-50%"]
    
    E --> E1["AI Resolution: 10-20%"]
    E --> E2["Escalation: 80-90%<br/>Refer to AE"]
    
    style C fill:#a8e6cf
    style D fill:#ffd3b6
    style E fill:#ffaaa5
```

---

#### Type 1: Specific Equipment (Part Number Known)

**Customer Says**: "Do you have model XYZ-1000 available?"

**Resolution Path**:

```mermaid
graph LR
    A["Part Number<br/>Query"] --> B["Check Perfect<br/>Inventory"]
    B --> C{Available<br/>Now?}
    
    C -->|Yes| D["Return Available<br/>Warehouse Location"]
    C -->|No| E["Check Status"]
    
    E --> F{Status?}
    F -->|In Repair| G["Calculate Lead<br/>Time"]
    F -->|On Order| H["Check ETA"]
    F -->|Broken| I["Search Alternatives"]
    
    G --> J["Recommend:<br/>Wait vs Substitute"]
    H --> J
    I --> J
    
    D --> K["Quote<br/>Complete"]
    J --> K
    
    style A fill:#e0f2f7
    style K fill:#c8e6c9
```

---

#### Type 2: Application/Test Type

**Customer Says**: "We need to test for RF interference in the 2-4 GHz band while driving around"

**Resolution Path**:

```mermaid
graph LR
    A["Application<br/>Description"] --> B["Understand<br/>Requirements"]
    B --> C["Match to Equipment<br/>Capabilities"]
    C --> D["Identify<br/>Prerequisites"]
    D --> E{All Prereqs<br/>Available?}
    
    E -->|Yes| F["Rank Options<br/>by Spec Match"]
    E -->|No| G["Escalate for<br/>PG Decision"]
    
    F --> H["Return Ranked<br/>Recommendations<br/>with Pricing"]
    
    style A fill:#fff3e0
    style H fill:#c8e6c9
```

**Key Business Rule**: 
"You can UP-sell bandwidth (customer needs 13 GHz, we offer 16 GHz) but CANNOT DOWN-sell bandwidth (customer needs 13 GHz, we only have 8 GHz = no match)"

---

#### Type 3: Problem Description (Vague)

**Customer Says**: "We're having signal issues with our test setup"

**Resolution Path**:

```mermaid
graph LR
    A["Vague Problem<br/>Description"] --> B["Ask Clarifying<br/>Questions"]
    B --> C{Enough Info<br/>Gathered?}
    
    C -->|Yes| D["Suggest Equipment<br/>Based on Patterns"]
    C -->|No| E["Ask More<br/>Questions"]
    
    E --> C
    D --> F{Confidence<br/>High?}
    
    F -->|Yes| G["Return<br/>Recommendations"]
    F -->|No| H["Escalate to<br/>Application Engineer"]
    
    style A fill:#fce4ec
    style G fill:#c8e6c9
    style H fill:#ffccbc
```

---

## Real-World Use Case Examples

### USE CASE 1: Power Supply Substitution Decision

**Actors**: Sales Rep (Sarah), Product Group (John), Customer (General Dynamics)

**Scenario**: Customer needs 1 kV DC, 25 amps power supply for circuit testing

#### What Happened (Current State)

```mermaid
sequenceDiagram
    actor Customer
    participant Sarah as Sales Rep
    participant John as Product Group
    participant Perfect as Perfect System
    participant D365 as D365 Europe
    participant Supplier as Supplier

    Customer->>Sarah: Need 1kV DC, 25A supply<br/>By Dec 15
    Sarah->>Perfect: Search for power supplies
    Perfect-->>Sarah: Found 5 options
    Sarah->>John: Which one should we use?
    John->>Perfect: Check all 5 in detail
    John->>D365: Check European warehouse
    John->>Supplier: Check Delta lead times
    Supplier-->>John: 5 weeks for repair
    John->>Sarah: Options: Buy new or upgrade<br/>Takes 2-3 hours analysis
    Sarah->>Customer: Here are options...<br/>Customer calls competitor
    Customer-->>Sarah: We'll call you back
```

**Timeline**: 2-3 hours | **Outcome**: Lost deal to competitor

---

#### With AI Product Advisor (Future State)

```mermaid
graph TD
    A["Query: 1kV DC, 25A<br/>Need by 12/15"] --> B["AI Analyzes All 5 Units"]
    B --> C["Real-Time Status Check"]
    C --> C1["Delta: 2 available<br/>2 broken - 5 weeks repair"]
    C --> C2["DC-5: 1 available<br/>0 in repair"]
    C --> C3["Roadie: 5 available<br/>0 in repair"]
    
    B --> D["Pull Real-Time Pricing"]
    D --> D1["Delta: 300/month"]
    D --> D2["DC-5: 1000/month"]
    D --> D3["Roadie: 800/month"]
    
    B --> E["Calculate Lead Times"]
    E --> E1["Can meet 12/15?"]
    
    B --> F["Generate Recommendation"]
    F --> F1["Rank 1: DC-5 - Available NOW<br/>1000/month - Meets Spec"]
    F --> F2["Rank 2: Roadie - Available NOW<br/>800/month - Meets Spec"]
    F --> F3["Rank 3: Delta - 5 week wait<br/>300/month - If you wait"]
    
    F1 --> G["Sales Presents Options<br/>to Customer"]
    F2 --> G
    F3 --> G
    
    style A fill:#e3f2fd
    style G fill:#c8e6c9
```

**Timeline**: 10-15 seconds | **Outcome**: Deal closed immediately

---

### USE CASE 2: Oscilloscope with Probes Package Deal

**Actors**: Sales Rep, Product Group (John), Customer (Tech startup)

**Scenario**: Customer needs 13 GHz oscilloscope for PCI Express 5 testing

#### Decision Tree for Complex Configuration

```mermaid
graph TD
    A["Customer Need:<br/>13 GHz Scope<br/>PCI Express 5 Testing"] --> B["Search Available Inventory"]
    
    B --> C{13 GHz Available?}
    C -->|No| D["Check Alternatives:<br/>16 GHz Available?"]
    C -->|Yes| E["Return 13 GHz Options"]
    
    D --> F{16 GHz Available?}
    F -->|Yes| G["Evaluate Bandwidth<br/>Up-sell Acceptable"]
    F -->|No| H["Check Other Options"]
    
    G --> I["Identify Prerequisites"]
    I --> I1["Probes Required: Yes"]
    I --> I2["Probe Sets Needed: 2"]
    
    I1 --> J["Check Probe Availability"]
    J --> J1["In Stock: 1 set"]
    J --> J2["On Order: 2 sets<br/>ETA: TBD"]
    
    J1 --> K["Decision Point"]
    J2 --> K
    
    K --> L{How to Configure?}
    L -->|Option A| M["16GHz + 2 Probes<br/>10K/month<br/>Second probe on backorder"]
    L -->|Option B| N["20GHz + 2 Probes<br/>12K/month<br/>More bandwidth"]
    L -->|Option C| O["16GHz + 1 Probe<br/>8K/month<br/>Second probe delayed"]
    
    M --> P["Escalate Probe<br/>Purchase to PG<br/>for Approval"]
    N --> Q["Quote Complete"]
    O --> Q
    
    style A fill:#fff3e0
    style Q fill:#c8e6c9
    style P fill:#ffccbc
```

---

### USE CASE 3: Multi-Location Inventory Search

**Actors**: Sales Rep (US-based), Product Group, Customer (International)

**Scenario**: US Customer needs equipment, not available in US warehouse

#### Geographic Prioritization Logic

```mermaid
graph TD
    A["Customer Query:<br/>US-based Customer"] --> B["Set Geographic Priority"]
    
    B --> C["Priority 1: US Warehouses"]
    C --> D{Found?}
    
    D -->|Yes| E["Return US Options<br/>Fastest Delivery"]
    D -->|No| F["Ask User Permission"]
    
    F --> G{Search Europe?}
    
    G -->|No| H["Return No Results<br/>or Alternative Options"]
    G -->|Yes| I["Priority 2:<br/>European Warehouses"]
    
    I --> J["Check D365 Inventory"]
    J --> J1["Denmark Warehouse"]
    J --> J2["Belgium Warehouse"]
    
    J1 --> K["Calculate Lead Time"]
    J2 --> K
    
    K --> L{Can Meet<br/>Need Date?}
    L -->|Yes| M["Return EU Option<br/>with Lead Time"]
    L -->|No| N["Inform User:<br/>Cannot Meet Timeline"]
    
    E --> O["Sales Presents Options"]
    M --> O
    N --> O
    
    style A fill:#e3f2fd
    style O fill:#c8e6c9
```

---

## Business Rules & Escalation Triggers

### The Business Rules Framework

```mermaid
graph TD
    A["Customer Query<br/>Arrives at AI"] --> B["Apply Business Rules"]
    
    B --> C["Rule Check:<br/>Incomplete Requirements?"]
    C -->|Yes| D["Ask Clarifying Questions"]
    D --> E{Sufficient Info?}
    E -->|No| F["Escalate to Product Group"]
    E -->|Yes| G["Continue Processing"]
    
    G --> H["Rule Check:<br/>Complex Configuration?"]
    H -->|Yes| I["Show Prerequisites<br/>Flag for PG"]
    H -->|No| J["Continue"]
    
    J --> K["Rule Check:<br/>Buy vs Substitute Decision?"]
    K -->|Yes| L["Present Trade-offs<br/>Escalate for Decision"]
    K -->|No| M["Continue"]
    
    M --> N["Rule Check:<br/>Confidence Level?"]
    N -->|Low| O["Flag with Confidence %<br/>Recommend Escalation"]
    N -->|High| P["Generate Recommendation"]
    
    P --> Q{Require PG Sign-off?}
    Q -->|Yes| R["Escalate with Analysis"]
    Q -->|No| S["Provide Direct Answer"]
    
    F --> T["Route to Product Group"]
    L --> T
    R --> T
    S --> U["Sales Gets Answer"]
    
    style A fill:#e3f2fd
    style U fill:#c8e6c9
    style T fill:#ffccbc
```

---

## Key Data Points Required

### Data Dependency Map

```mermaid
graph TD
    subgraph Perfect["Perfect Inventory System"]
        P1["Equipment Model<br/>Description"]
        P2["Real-Time Availability<br/>Status"]
        P3["Lead Time Info"]
        P4["Configuration Codes"]
        P5["Software Licenses"]
    end
    
    subgraph D365["D365 European System"]
        D1["European Inventory"]
        D2["Regional Lead Times"]
        D3["Regional Pricing"]
    end
    
    subgraph Pricing["Pricing Data"]
        PR1["30-Day Rental Rate"]
        PR2["List Price"]
        PR3["Add-On Pricing"]
        PR4["Last Updated Date"]
    end
    
    subgraph Specs["Product Specifications"]
        S1["Feature Interdependencies"]
        S2["Configuration Matrices"]
        S3["Compatible Accessories"]
        S4["Software Compatibility"]
    end
    
    AI["AI Product Advisor<br/>Engine"]
    
    P1 --> AI
    P2 --> AI
    P3 --> AI
    P4 --> AI
    P5 --> AI
    D1 --> AI
    D2 --> AI
    D3 --> AI
    PR1 --> AI
    PR2 --> AI
    PR3 --> AI
    PR4 --> AI
    S1 --> AI
    S2 --> AI
    S3 --> AI
    S4 --> AI
    
    style AI fill:#bbdefb
    style Perfect fill:#c8e6c9
    style D365 fill:#c8e6c9
    style Pricing fill:#ffe0b2
    style Specs fill:#f8bbd0
```

---

## Pricing Awareness & Transparency

### Real-Time Pricing Flow

```mermaid
graph LR
    A["Customer Query<br/>for Equipment"] --> B["Retrieve Latest Data<br/>from Perfect"]
    
    B --> C["Check Data Age"]
    C --> C1{Older than<br/>30 Days?}
    
    C1 -->|Yes| D["Add Warning Flag"]
    C1 -->|No| E["Data is Fresh"]
    
    D --> F["Display Pricing Card<br/>with Warning"]
    E --> F
    
    F --> G["Show Recommendation<br/>with Price Details"]
    
    style A fill:#e3f2fd
    style F fill:#c8e6c9
    style D fill:#ffccbc
```

### Equipment Recommendation Display

```mermaid
graph TD
    A["Equipment Result"] --> B["Display Card"]
    
    B --> B1["Model Name<br/>& Description"]
    B --> B2["Key Specifications"]
    B --> B3["Availability Status"]
    B --> B4["Warehouse Location"]
    B --> B5["30-Day Rental Price"]
    B --> B6["List Price"]
    B --> B7["Last Price Updated"]
    B --> B8["Required Accessories"]
    B --> B9["Alternative Options"]
    B --> B10["Action Buttons"]
    
    B7 --> C{Price Age?}
    C -->|Recent| D["Green Indicator"]
    C -->|30+ Days| E["Yellow Warning"]
    C -->|60+ Days| F["Red Alert"]
    
    style A fill:#e3f2fd
    style D fill:#c8e6c9
    style E fill:#fff9c4
    style F fill:#ffcdd2
```

---

## Follow-Up Questions Strategy

### Smart Questioning System

```mermaid
graph TD
    A["AI Recognizes<br/>Product Category"] --> B{What Category?}
    
    B -->|Oscilloscope| C["Ask Scope Questions"]
    B -->|Power Supply| D["Ask Supply Questions"]
    B -->|Spectrum Analyzer| E["Ask Analyzer Questions"]
    
    C --> C1["What's the primary<br/>measurement app?"]
    C --> C2["What bandwidth<br/>needed?"]
    C --> C3["How many channels?"]
    C --> C4["Sampling rate?"]
    C --> C5["Probes needed?"]
    C --> C6["Brand preference?"]
    
    D --> D1["Primary application?"]
    D --> D2["DC or AC+DC?"]
    D --> D3["Voltage range?"]
    D --> D4["Current rating?"]
    D --> D5["4-quadrant needed?"]
    D --> D6["Remote programming?"]
    
    E --> E1["Measurement type?"]
    E --> E2["Frequency range?"]
    E --> E3["Lab or field?"]
    E --> E4["Real-time needed?"]
    E --> E5["Preamplifier needed?"]
    
    C1 --> X["Compile into Query"]
    C2 --> X
    C3 --> X
    C4 --> X
    C5 --> X
    C6 --> X
    
    X --> Y["Search with Full Context"]
    Y --> Z["Return Optimized Results"]
    
    style A fill:#e3f2fd
    style Z fill:#c8e6c9
```

---

## Success Metrics Overview

### Response Time Improvement

```mermaid
graph LR
    subgraph Before["BEFORE AI System"]
        B1["Type 1 Query:<br/>15 minutes"]
        B2["Type 2 Query:<br/>45 minutes"]
        B3["Type 3 Query:<br/>2 hours"]
    end
    
    subgraph After["AFTER AI System"]
        A1["Type 1 Query:<br/>2 minutes"]
        A2["Type 2 Query:<br/>5 minutes"]
        A3["Type 3 Query:<br/>15 min escalation"]
    end
    
    Before --> Results
    After --> Results
    
    Results --> R1["87% Faster"]
    Results --> R2["89% Faster"]
    Results --> R3["87% Faster"]
    
    style B1 fill:#ffcdd2
    style B2 fill:#ffcdd2
    style B3 fill:#ffcdd2
    style A1 fill:#c8e6c9
    style A2 fill:#c8e6c9
    style A3 fill:#c8e6c9
```

---

### Escalation Reduction

```mermaid
graph LR
    subgraph Before["BEFORE: 40-60 Escalations/Day"]
        B1["Type 1:<br/>20% escalation"]
        B2["Type 2:<br/>60% escalation"]
        B3["Type 3:<br/>85% escalation"]
    end
    
    subgraph After["AFTER: 12-18 Escalations/Day"]
        A1["Type 1:<br/>10% escalation"]
        A2["Type 2:<br/>40% escalation"]
        A3["Type 3:<br/>85% escalation<br/>→ Refer to AE"]
    end
    
    Before --> Compare["70% Overall<br/>Escalation<br/>Reduction"]
    After --> Compare
    
    style Before fill:#ffcdd2
    style After fill:#c8e6c9
    style Compare fill:#bbdefb
```


## Product Taxonomy

### ElectroRent Product Hierarchy

```mermaid
graph TD
    A["Segment<br/>Electronic Test Equipment"]
    
    B["Class<br/>Oscilloscopes"]
    
    C["Part Family<br/>UXR Series"]
    
    D["Model<br/>UXR-16GHz"]
    
    E["Part Number<br/>123-4567-01"]
    
    F["Asset Serial<br/>KEYX-UXR-0045"]
    
    A --> B
    B --> C
    C --> D
    D --> E
    E --> F
    
    style A fill:#e3f2fd
    style B fill:#bbdefb
    style C fill:#90caf9
    style D fill:#64b5f6
    style E fill:#42a5f5
    style F fill:#2196f3
```

---

## Appendix: Quick Reference Guide

### When to Escalate Decision Tree

```mermaid
graph TD
    A["Query Received"] --> B{Meets All of:<br/>1. Complete Info<br/>2. Clear Status<br/>3. High Confidence}
    
    B -->|Yes| C["Provide Direct<br/>Recommendation"]
    B -->|No| D["Escalate to<br/>Product Group"]
    
    C --> E["Sales Closes<br/>Deal"]
    D --> F["PG Provides<br/>Expert Input"]
    F --> E
    
    style A fill:#e3f2fd
    style C fill:#c8e6c9
    style E fill:#c8e6c9
    style D fill:#ffccbc
```

---

**End of Document**

