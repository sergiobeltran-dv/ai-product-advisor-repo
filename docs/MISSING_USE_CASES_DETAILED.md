# Missing Use Cases - Detailed Scenarios

**Purpose**: Complement coworker's 13-use-case framework with detailed technical scenarios, data flows, and implementation requirements.

**Document Version**: 1.0  
**Date**: November 2025

---

## Missing Use Case 1: Backordered/Long-Lead Decision Tree

### Business Context
**Coworker's UC2**: Backordered or Long-Lead Products  
**Gap**: My documentation did not include explicit logic for handling backorders with customer deadline constraints.

---

### Scenario: Sales Needs Fast Decision on Backorder Trade-offs

**Actors**: 
- Sarah (Sales Rep)
- John (Product Group)
- Customer (Tech Company)

**Setup**:
Customer needs: RF Spectrum Analyzer model Keysight N9040B  
Status: Out of stock in US, 4-week backorder available  
Customer deadline: Needs equipment in 2 weeks for customer demonstration

---

### Current State (Without AI)

```
Customer asks: "Do you have N9040B available?"

Sarah's Process:
1. Checks Perfect → "Backordered - Lead time TBD"
2. Unclear on exact ETA → Escalates to John
3. John checks supplier status
4. Takes 1 hour to confirm: "Available in 4 weeks"
5. John must make decision: Wait or find alternative?
6. Back-and-forth with Sarah on alternatives: 30 min
7. TOTAL TIME: 1.5 hours
8. Customer waits during this time

Outcome: Customer may accept competitor's offer while waiting
```

---

### With AI Product Advisor

```
Sales Input: "Customer needs N9040B. Deadline: 2 weeks. Can we fulfill?"

AI System Decision Tree:
├─ Check Perfect inventory
│  └─ N9040B: Status = "Backordered"
│     ├─ Backorder ETA: 4 weeks
│     └─ Current backorder qty: 2 units
│
├─ Evaluate against deadline (2 weeks)
│  └─ Decision: 4 weeks > 2 weeks = NOT FEASIBLE
│
├─ Query alternatives automatically:
│  ├─ Same model in Europe? 
│  │  └─ Yes: 1 available, 8-day shipping = arrives day 8 ✓
│  ├─ Higher bandwidth alternative?
│  │  └─ N9041B: 3 available, ships next day ✓
│  ├─ Different class substitute?
│  │  └─ Rohde FSW40: 2 available ✓
│  └─ Lower-cost substitute?
│     └─ Keysight N9010B: 1 available ✓
│
├─ Price all options:
│  ├─ Wait for N9040B (4 weeks): $8,500/month
│  ├─ Ship from Europe (8 days): $8,500 + $1,200 shipping
│  ├─ N9041B upgrade (1 day): $10,000/month
│  ├─ Rohde FSW40 (1 day): $9,500/month
│  └─ N9010B (1 day): $7,000/month
│
└─ AI Recommendation:
   "CANNOT deliver N9040B by deadline (4-week backorder).
    
    RECOMMENDED OPTIONS (Stack Ranked by Feasibility):
    
    1️⃣ BEST: N9041B [1-day delivery, $10K/mo]
       ├─ Meets all specs
       ├─ Available immediately
       └─ $1,500 premium vs. N9040B
    
    2️⃣ ALTERNATIVE: Ship N9040B from Europe [8-day delivery, $8.5K + $1.2K shipping]
       ├─ Exact model customer wants
       ├─ Within deadline (8 days < 2 weeks)
       └─ Requires European warehouse coordination
    
    3️⃣ BUDGET: N9010B [1-day delivery, $7K/mo]
       ├─ Lower bandwidth (45 GHz vs 50 GHz)
       ├─ Adequate for most applications
       └─ $1,500/month savings
    
    → ESCALATION: If customer chooses Option 2 (Europe), 
      contact John to coordinate shipping + customs clearance"
```

---

### Data Flow

```
CUSTOMER DEADLINE = 2 weeks

Perfect System (Real-time)
├─ Model: N9040B
├─ Status: Backordered
├─ Backorder ETA: 4 weeks
└─ Supplier: Keysight

D365 European Warehouse
├─ N9040B: 1 available
├─ Shipping lead time: 8 days
└─ Total arrive date: Day 8 ✓ (within deadline)

Available Alternatives (Ranked)
├─ Keysight N9041B: 3 units (1 day) → $10K/mo
├─ Rohde FSW40: 2 units (1 day) → $9.5K/mo
└─ Keysight N9010B: 1 unit (1 day) → $7K/mo

DECISION: 
  ├─ If customer can't wait 4 weeks → Recommend N9041B or Europe option
  ├─ If customer needs lowest cost → Recommend N9010B
  └─ If customer wants exact model → Recommend Europe shipping
```

---

### Business Rules

**Rule 1**: "If backorder ETA > customer deadline → immediately surface alternatives"  
**Rule 2**: "Always check European warehouses before telling customer 'not available'"  
**Rule 3**: "Never force customer to wait if reasonable alternatives exist"  
**Rule 4**: "Flag international shipping options for PG approval (customs, import rules)"

---

### Escalation Triggers

✅ **Escalate to Product Group if**:
- Customer chooses European warehouse option → coordinate with Belgium team
- Backorder ETA changes → re-evaluate alternatives
- Customer challenges pricing on alternatives
- International shipping complexity > standard

---

### Implementation Requirements

**Data Needed**:
- Perfect: Backorder status, ETA, quantity
- D365: European inventory by location
- Pricing: Cost of alternatives, shipping fees
- Rules: Lead-time calculation logic

**System Capabilities**:
- Deadline vs. lead-time comparison
- Multi-warehouse search
- Automatic alternative ranking
- Escalation routing

---

## Missing Use Case 2: Configuration Cost vs. Shipping Trade-Off

### Business Context
**Coworker's UC6**: Configuration Cost vs. Shipping Trade-Off  
**Gap**: My documentation didn't address TCO (total cost of ownership) analysis with reconfiguration vs. shipping decisions.

---

### Scenario: Local Reconfiguration vs. European Shipment

**Actors**:
- Tom (Sales Rep)
- Sarah (Product Group, Logistics Lead)
- Customer (Manufacturing Company)

**Setup**:
Customer needs: Oscilloscope with specific software option  
Available in US: Unit without software (can add locally)  
Available in Europe: Unit fully configured with software  
Customer timeline: Needs in 1 week

---

### Current State (Without AI)

```
Tom searches Perfect:
1. Finds US unit: Available now, but needs software install
2. Finds Europe unit: Pre-configured, ready to ship
3. Unclear which option is better → Escalates to Sarah
4. Sarah must analyze:
   - Software licensing cost (est. $5K)
   - Installation labor (est. 2 hours @ $100/hr)
   - vs. Shipping cost from Europe ($2K) + lead time (8 days)
5. Sarah checks with software licensing team: 30 min
6. Back to Tom: "Europe option is cheaper if timeline allows"
7. Tom confirms with customer
8. TOTAL TIME: 1.5-2 hours

Problem: If analysis is wrong, escalates further
```

---

### With AI Product Advisor

```
Sales Input: "Customer needs oscilloscope with TIM software. 
             Deadline: 1 week. What's the best option?"

AI System Analysis:

OPTION A - Local Configuration
├─ Equipment: US unit available now
├─ Software license cost: $5,000
├─ Installation labor: 2 hours (est. $200)
├─ Shipping to customer: Standard (included)
├─ Lead time: 2 days (install + test)
├─ Total cost: $5,200
├─ Delivery date: Day 2 ✓
└─ Profit impact: Software revenue recognized

OPTION B - Ship from Europe
├─ Equipment: Pre-configured in Denmark
├─ Software: Already installed & licensed
├─ Shipping to customer: DHL overnight (premium)
├─ Customs & import: 1-2 days processing
├─ Lead time: 8 days
├─ Total cost: $2,000 (shipping only)
├─ Delivery date: Day 8 ✓ (meets deadline, but tight)
└─ Profit impact: Lower margin (no software sale)

TOTAL COST OF OWNERSHIP (TCO) Analysis:
┌────────────────────────────────────────────┐
│ Option A (Local Config)                    │
│ ├─ Equipment cost: $0 (already owned)      │
│ ├─ Software license: $5,000                │
│ ├─ Labor: $200                             │
│ ├─ Shipping: Included                      │
│ └─ TOTAL: $5,200 | Arrives: Day 2          │
├────────────────────────────────────────────┤
│ Option B (Europe Shipment)                 │
│ ├─ Equipment cost: $0 (already owned)      │
│ ├─ International shipping: $2,000          │
│ ├─ Customs processing: $200                │
│ ├─ Extra lead time cost: $500 (risk)       │
│ └─ TOTAL: $2,700 | Arrives: Day 8          │
└────────────────────────────────────────────┘

RECOMMENDATION:
"OPTION A (Local Configuration) is BETTER
 ├─ Cost difference: $2,500 more, BUT
 ├─ Arrives 6 days earlier (Day 2 vs Day 8)
 ├─ Software revenue benefit: $5,000
 ├─ Lower risk of customs delays
 └─ Higher customer satisfaction (faster delivery)

 → DECISION: Proceed with Option A (local config)
 → ACTION: Escalate to PG for software license approval"

```

---

### Data Flow

```
Perfect System (US Inventory)
├─ Oscilloscope model: XYZ-16GHz
├─ Qty available: 3 units
├─ Current config: Base (no software)
└─ Can be reconfigured: Yes

D365 System (European Inventory)
├─ Same model: 1 unit available
├─ Current config: TIM software + probes
├─ Shipping cost to US: $2K
└─ Shipping time: 8 days

Pricing Database
├─ TIM software license: $5,000
├─ Install labor rate: $100/hour
├─ Install time estimate: 2 hours = $200
└─ Total config cost: $5,200

COMPARISON ENGINE:
  Input: Customer deadline (1 week)
  ├─ Check Option A feasibility: Day 2 < 7 days ✓
  ├─ Check Option B feasibility: Day 8 > 7 days ✗ (marginal)
  ├─ Calculate TCO for both
  └─ Recommend lowest-cost option that meets deadline
```

---

### Business Rules

**Rule 1**: "Always compare TCO (total cost), not just direct cost"  
**Rule 2**: "If local option meets deadline and cost is comparable → recommend local"  
**Rule 3**: "Escalate for PG approval if software licensing is complex"  
**Rule 4**: "Flag shipping risks (customs delays) for international options"

---

### Escalation Triggers

✅ **Escalate to Product Group if**:
- Customer deadline is marginal (e.g., need by day 7, Europe option arrives day 8)
- Software licensing uncertainty → unclear if license is transferable
- Reconfiguration complexity > estimated time
- International shipping risk > acceptable threshold

---

### Implementation Requirements

**Data Needed**:
- Perfect: US inventory, configuration status, reconfiguration capability
- D365: European inventory, pre-configured status
- Pricing: Software costs, labor rates, shipping costs
- Rules: Reconfiguration time estimates, lead-time calculations

**System Capabilities**:
- Multi-option TCO calculation
- Risk assessment (customs delays, configuration risks)
- Automatic recommendation ranking
- Escalation conditions

---

## Missing Use Case 3: Non-Standard Product Requests

### Business Context
**Coworker's UC11**: Non-Standard Product Requests  
**Gap**: My documentation didn't cover handling requests for equipment ElectroRent doesn't stock.

---

### Scenario: Customer Requests Model Not in Inventory

**Actors**:
- Rachel (Sales Rep)
- Mark (Product Group Manager)
- Customer (Defense Contractor)

**Setup**:
Customer request: "Do you have a Rohde & Schwarz FSVR30 available?"  
Reality: ElectroRent doesn't stock this model  
Decision: Should we purchase it or suggest alternatives?

---

### Current State (Without AI)

```
Rachel searches Perfect:
1. Finds: Model not in system
2. Checks manual list: FSVR30 not in catalog
3. Escalates to Mark: "Can we get this?"
4. Mark must research:
   - Is this a requested model worth stocking?
   - What are the alternatives?
   - What's the cost to purchase?
   - Can we acquire it quickly?
5. Research takes 1-2 hours
6. Back to Rachel with alternatives
7. TOTAL TIME: 1-2 hours

Risk: Customer calls competitor while waiting
Outcome: Maybe we lose the opportunity
```

---

### With AI Product Advisor

```
Sales Input: "Customer needs Rohde & Schwarz FSVR30. 
             What can we do?"

AI System Decision Tree:

STEP 1: Check if model exists in ElectroRent inventory
├─ Search Perfect: NOT FOUND
└─ Search D365 Europe: NOT FOUND

STEP 2: Determine if model is relevant
├─ Product class: Vector Network Analyzer
├─ Frequency range: DC to 30 GHz
├─ Key spec: Real-time vector capability
└─ Status: **KNOWN MODEL** (in our reference data)

STEP 3: Find acceptable alternatives (in order of preference)
├─ Same brand, similar spec:
│  ├─ Rohde FSMR26 (26 GHz): 1 available
│  └─ Rohde FSV40 (40 GHz, higher): 0 available
├─ Different brand, comparable spec:
│  ├─ Keysight N9926A (26 GHz): 2 available
│  ├─ Anritsu MS2090A (20 GHz): 1 available
│  └─ HP/Agilent E5071C (20 GHz): 1 available
└─ Down-sell option (lower-spec):
   ├─ Rohde FSMR6 (6 GHz): 3 available
   └─ Keysight N9010B (50 GHz): 5 available (over-spec)

STEP 4: Decision logic
├─ Perfect alternative available? 
│  └─ YES: FSMR26 is close enough → Recommend
├─ Customer's exact specs unclear?
│  └─ YES: Ask clarifying questions
└─ If NO good alternative → FLAG FOR PG

AI Response:

"FSVR30 not in our current inventory.

However, we have EXCELLENT alternatives:

✅ BEST MATCH: Rohde & Schwarz FSMR26 [1 available]
   ├─ Same brand preference
   ├─ Comparable frequency (26 vs 30 GHz)
   ├─ Available NOW
   ├─ Price: $12,500/month
   ├─ Only $1,500/month less than FSVR30
   └─ Meets 95% of typical use cases

ℹ️ OTHER OPTIONS: 
   ├─ Keysight N9926A [similar specs, $11K/month]
   ├─ Anritsu MS2090A [20 GHz, $9K/month]

❓ QUESTION FOR CUSTOMER:
   'What's the critical frequency limit? If you can work 
    with 26 GHz instead of 30 GHz, FSMR26 is our best option.'

📋 FOR PRODUCT GROUP:
   [PG Escalation] 'If customer needs EXACTLY FSVR30, 
    should we acquire? Purchase cost ~$40K. 
    Estimated rental value: $15K/month = 3-month payback.'

→ ACTION: Use FSMR26 as primary recommendation
→ ESCALATION: If customer insists on FSVR30, PG to decide purchase
```

---

### Business Rules

**Rule 1**: "If exact model not available → surface best alternatives immediately"  
**Rule 2**: "Recommend alternatives in this order: (1) Same brand, (2) Comparable brand, (3) Different brand"  
**Rule 3**: "Flag all non-standard requests for PG strategic review (potential new product line)"  
**Rule 4**: "If confidence in alternative match < 75% → escalate to PG"

---

### Escalation Triggers

✅ **Escalate to Product Group if**:
- Customer insists on exact model not in stock
- Unclear if we should acquire this model for rental fleet
- Multiple requests for same model → may indicate market demand
- Customer willing to wait for acquisition

---

### Implementation Requirements

**Data Needed**:
- Reference database: All known models (ElectroRent + industry)
- Perfect: Current inventory
- Mapping: Product similarity/substitution matrix
- Business logic: When to acquire new models

**System Capabilities**:
- Cross-reference external product catalogs
- Automatic alternative suggestion
- Confidence scoring on matches
- Strategic opportunity flagging

---

## Missing Use Case 4: Rental Pricing Validation

### Business Context
**Coworker's UC7**: Rental Pricing Validation  
**Gap**: My documentation mentioned pricing rules but didn't create explicit scenario for stale pricing.

---

### Scenario: Sales Questions if Pricing is Current

**Setup**:
Sales Rep quotes customer: "Oscilloscope rental is $8,500/month"  
But system shows: Last price update was 45 days ago (older than 30-day threshold)  
Actual current price: $8,800/month (3% increase)

---

### Current Situation (Without AI)

```
Customer (via email): "We'll take 3 months @ $8,500/month"
Sales inputs quote into system
System processes quote
→ LATER: Finance notices pricing mismatch
→ Invoice shows $8,800 (current price) but quote was $8,500
→ Customer disputes charge
→ Correction required → customer upset → relationship damage
```

---

### With AI Product Advisor

```
Sales Input: "Quote N9040B oscilloscope for 3-month rental"

AI System Check:

Pricing Database Query:
├─ N9040B 30-day rental: $8,500
├─ Last price updated: 45 days ago
└─ ⚠️ WARNING: Data is STALE (> 30 days)

ALERT DISPLAY:
┌────────────────────────────────────────────┐
│ ⚠️ PRICING FRESHNESS WARNING               │
├────────────────────────────────────────────┤
│ Equipment: N9040B Oscilloscope             │
│ Listed Price: $8,500/month                 │
│ Data Updated: 45 days ago                  │
│ Status: ⛔ STALE (Verify before quoting)    │
├────────────────────────────────────────────┤
│ Recommended Action:                        │
│ [ Verify with PG ] [ Quote As-Is ] [ Skip]│
└────────────────────────────────────────────┘

Sales Action: Click "Verify with PG"

AI System:
├─ Routes to Product Group for live pricing check
├─ Shows: Current price updated 5 days ago = $8,800/month
├─ Alerts Sales: "Price increased 3.5% since last update"
├─ Recommends: Quote customer $8,800 (current)
└─ Offers: "If customer resists, check with PG on promotional pricing"

Sales Outcome:
✅ Quotes accurate current pricing
✅ Avoids customer disputes
✅ PG has visibility into pricing inquiries
```

---

### Business Rules

**Rule 1**: "Flag all pricing data > 30 days old as STALE before quoting"  
**Rule 2**: "Require PG verification for stale pricing before finalizing quote"  
**Rule 3**: "Show both last-known price AND verification request"  
**Rule 4**: "Track pricing verification requests as escalation metric"

---

## Missing Use Case 5: Discounted/Over-Optioned Equipment

### Business Context
**Coworker's UC8**: Discounted or Over-Optioned Units  
**Gap**: My documentation didn't address promotional opportunities like selling rental units or over-optioned equipment at discounts.

---

### Scenario: Offering Over-Optioned Unit at Discount

**Setup**:
ElectroRent inventory: Keysight N9040B with options B1X, B3, B12  
Customer request: Base N9040B (no options)  
Opportunity: Offer over-optioned unit at discount (customer gets free options)

---

### Current Situation (Without AI)

```
Sales searches for N9040B base unit
Finds: Only over-optioned units available
Dilemma: 
  ├─ Quote customer for base unit → no inventory available
  ├─ Offer over-optioned unit → customer doesn't need options
  └─ Escalate to PG → Takes 1 hour
  
PG decision: "Offer it at 15% discount (cost of options already paid)"
Sales: Quotes with discount
Customer: Accepts
```

---

### With AI Product Advisor

```
Sales Input: "Customer needs base N9040B"

AI System Check:

Perfect Query:
├─ N9040B base units available: 0
├─ N9040B with options available:
│  ├─ Option B1X,B3,B12 (over-optioned): 1 unit
│  └─ Option B1X only: 2 units
├─ Customer needs: Base (no options)
└─ Decision: Over-optioned unit could work?

AI Analysis:

"Perfect match not available, BUT we have a BETTER OPTION:

📦 INVENTORY OPPORTUNITY:

Equipment: N9040B with Premium Options
├─ Includes: B1X (Hardware upgrade)
├─ Includes: B3 (Advanced analysis)
├─ Includes: B12 (Calibration cert)
├─ Value of options: ~$2,500
├─ Standard rental: $8,500/month

💰 PROMOTIONAL OFFER:
├─ Normally: Base $8,500 + options $2,500 = $11,000
├─ Our cost: Options already configured
├─ Suggested discount: 15-20% = $8,700/month
├─ Rationale: Move aged inventory, customer gets value

✅ RECOMMENDATION:
   'Offer N9040B with all options at $8,700/month (15% off)'
   ├─ Customer saves: $2,300/month vs. standalone pricing
   ├─ We move equipment: Reduces holding costs
   ├─ Customer upsell: Gets premium features at discount
   └─ Requires: PG approval for discount + terms"

Action Required: [ Offer to Customer ] [ Escalate ] [ Decline ]
```

---

### Business Rules

**Rule 1**: "Flag over-optioned equipment when base units unavailable"  
**Rule 2**: "Automatically calculate cost-justified discount for options already equipped"  
**Rule 3**: "Escalate for PG approval if discount > 20% or rental terms need adjustment"  
**Rule 4**: "Track promotional units to measure discount effectiveness"

---

## Summary Table: New Use Cases

| # | Coworker UC | Use Case | Priority | Phase |
|---|-------------|----------|----------|-------|
| 1 | UC2 | Backordered/Long-Lead Decision | HIGH | 2 |
| 2 | UC6 | Configuration Cost vs. Shipping | HIGH | 2 |
| 3 | UC11 | Non-Standard Product Requests | MEDIUM | 2 |
| 4 | UC7 | Rental Pricing Validation | MEDIUM | 2 |
| 5 | UC8 | Discounted/Over-Optioned Units | MEDIUM | 2 |

---

**Status**: Ready for Phase 2 implementation planning  
**Next Step**: Integrate into BUSINESS_USE_CASES_v2_ENHANCED.md  
**Owner**: AI Product Advisor Team


