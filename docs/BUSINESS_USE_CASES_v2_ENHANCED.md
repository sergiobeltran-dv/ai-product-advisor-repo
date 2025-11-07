# Business Use Cases: Sales to Product Group Interactions
## ElectroRent AI Product Advisor MVP

**Project**: ElectroRent AI Product Advisor MVP  
**Document Version**: 2.0 (Enhanced with Discovery Calls)  
**Date**: November 2025  
**Stakeholders**: Sales Team, Product Group, Management

---

## Executive Summary

This document outlines real-world business use cases derived from discovery calls with the ElectroRent Product Group and Sales team. These scenarios represent the core interactions between Sales and Product Group that the AI Product Advisor solution will automate and enhance. The system reduces escalations to Product Group by 70-80% while enabling Sales to serve customers faster with accurate, data-driven recommendations.

---

## Understanding the Business Context

### Current Process Flow

```
Customer Inquiry
    ↓
Sales Rep (doesn't know answer)
    ↓
Sales contacts Product Group via email/phone
    ↓
Product Group researches (manual work):
    • Checks Perfect (inventory system)
    • Reviews specifications
    • Looks up D365 (European warehouse data)
    • Checks data sheets
    • Evaluates alternatives
    ↓
Product Group responds (30 min - 4 hours)
    ↓
Sales communicates back to customer
    ↓
If follow-ups → cycle repeats (multiple delays)
```

### Desired Future State with AI Product Advisor

```
Customer Inquiry
    ↓
Sales Rep uses AI Product Advisor chatbot
    ↓
System provides INSTANT response with:
    • Live inventory data
    • Real-time pricing
    • Alternative options
    • Technical specifications
    ↓
Sales gives immediate answer to customer
    ↓
If complex → escalate to Product Group with AI analysis
```

---

## Core Use Cases from Discovery Calls

### Product Selection Scenario Breakdown

During discovery calls, Product Group identified **three core ways customers express their needs:**

#### **Type 1: Specific Equipment (Part Number Known)**
**Customer Says**: "Do you have model XYZ-1000 available?"

**Current State**:
- Sales checks Perfect inventory
- Often outdated or unclear availability status
- If unavailable, must escalate to Product Group
- Product Group searches alternatives manually

**With AI Product Advisor**:
- ✅ Instant confirmation of availability in local warehouse
- ✅ Suggest alternatives immediately with pricing
- ✅ Check D365 for European warehouse options
- ✅ Provide lead times for repair if needed

**Example Scenario (from calls)**:
> "General Dynamics needs a 1 kilovolt DC, 25-amp power supply. Salesperson John found 5 possible units in the system, but picked the cheapest option which was broken and required 5+ weeks repair. AI system would have:
> - Analyzed all 5 options
> - Flagged repair status and lead times
> - Ranked by actual availability vs. price vs. lead time
> - Recommended unit DC-5 (available immediately) at $1,000 vs. broken Delta at $300"

---

#### **Type 2: Application/Test Type (Customer specifies what they want to test)**
**Customer Says**: "We need to test for RF interference in the 2-4 GHz band while driving around"

**Current State**:
- Sales doesn't know what equipment does this
- Escalates to Product Group
- Product Group does research on application requirements
- Takes 2-4 hours

**With AI Product Advisor**:
- ✅ Understand the application requirement
- ✅ Match to equipment capabilities
- ✅ Provide compatible product recommendations
- ✅ Include required accessories and probes
- ✅ Show pricing for package

**Key Business Rule**: 
> "You can UP-sell bandwidth (customer needs 13 GHz, we offer 16 GHz) but CANNOT DOWN-sell bandwidth (customer needs 13 GHz, we only have 8 GHz = no match)"

---

#### **Type 3: Problem Description (Vague customer need)**
**Customer Says**: "We're having signal issues with our test setup"

**Current State**:
- Very unclear what equipment is needed
- Sales escalates to Applications Engineer (SAE/AE)
- Requires subject matter expert consultation
- Highest escalation rate (>80% need PG involvement)

**With AI Product Advisor**:
- ✅ Ask clarifying questions to narrow scope
- ✅ Suggest likely equipment based on patterns
- ✅ If can't determine → escalate to AE with analysis already done

**Escalation Pattern**:
- Type 1 (Part Number): 90% resolved by AI, 10% escalation
- Type 2 (Application): 50-60% resolved by AI, 40-50% escalation  
- Type 3 (Problem): 10-20% resolved by AI, 80-90% escalation → refer to AE

---

## Real-World Use Case Examples

### USE CASE 1: Power Supply Substitution Decision

**Actors**: Sales Rep (Sarah), Product Group (John), Customer (General Dynamics)

**Scenario**:
Customer needs: 1 kV DC, 25 amps power supply for circuit testing

**Current State (What Happened)**:
1. Sarah searches Perfect manually, finds 5 possible units
2. She picks the cheapest one (Delta at $300) because it's under budget
3. Turns out Delta units are all broken, need 5-week repair
4. Next option is $1,000 and available immediately
5. But it's a 2.5 kW unit with extra capacity they don't need
6. Sarah had to call John to decide: wait for repair or upgrade?
7. John had to contact European warehouse (D365) and Delta supplier
8. Total time: 2-3 hours
9. Customer called competitor while waiting

**With AI Product Advisor**:

```
Sales Input: "Looking for 1kV DC, 25A power supply. Need by 12/15"
│
AI System analyzes:
├─ Reviews all 5 matching units
├─ Checks real-time status from Perfect:
│  ├─ Delta units: 2 available, 2 broken (repair status)
│  ├─ DC-5: 1 available, 0 in repair
│  └─ Roadie: 5 available, 0 in repair
├─ Pulls real-time pricing:
│  ├─ Delta: $300/30-day rental
│  ├─ DC-5: $1,000/30-day rental
│  └─ Roadie: $800/30-day rental
├─ Evaluates lead times for repairs
└─ Considers need date (12/15)
│
AI Recommendation (Stack Ranked):
1. DC-5: Available NOW, $1,000, fully meets spec
2. Roadie: Available NOW, $800, fully meets spec
3. Delta: 2 broken (5-week repair), $300 if you wait
└─ Suggestion: "You have 3 weeks. I can reserve a unit 
   that's available now. Which would you prefer?"
```

**Business Value**:
- ✅ Immediate recommendation (vs. 2-3 hours)
- ✅ Sales keeps customer on line
- ✅ No escalation needed
- ✅ Informed trade-off decision (wait for cheap + broken OR get working + expensive)
- ✅ Sales closes deal NOW vs. competitor

---

### USE CASE 2: Oscilloscope with Probes Package Deal

**Actors**: Sales Rep, Product Group (John), Customer (Tech startup)

**Scenario**:
Customer needs: 13 GHz oscilloscope for PCI Express 5 testing

**Current State**:
1. Customer asks for 13 GHz scope
2. ElectroRent doesn't have 13 GHz in stock (inventory is 75% Keysight, scattered others)
3. Sarah finds a 16 GHz Keysight scope (can up-sell bandwidth)
4. But that scope is "light on probes" - only has 1 set, customer needs 2
5. John needs to decide: 
   - Buy 2 additional probes ($20K) for $10K rental deal?
   - Tell customer to buy their own probes?
   - Upgrade to different scope with more probes?
6. Sales back-and-forth with John: 1+ hour
7. Customer decision delayed

**With AI Product Advisor**:

```
Sales Input: "Need 13 GHz scope for PCI Express 5 testing, 2-month rental"
│
AI System:
├─ Understands PCI Express 5 testing requirements
├─ Recommends equipment family needed (Keysight UXR series)
├─ Identifies bandwidth match (16 GHz available, 13 GHz needed)
├─ CRITICAL: Recognizes prerequisite dependencies
│  └─ "For this scope, you need 2 probe sets (you have 1)"
├─ Retrieves live inventory:
│  ├─ 16 GHz scope: 1 available, 0 on repair
│  ├─ Probe sets available: 1 in stock, 2 on order (ETA: TBD)
│  └─ Alternatives: 20 GHz scope with 2 probes available
├─ Pricing:
│  ├─ 16 GHz scope + 1 probe: $8K/month
│  ├─ Additional probe rental: $2K/month
│  ├─ 20 GHz scope + 2 probes: $12K/month
│  └─ All pricing shows list + 30-day rental rates
└─ Status flags:
   └─ ⚠️ "Additional probes require special order - PG decision needed"
│
AI Recommendation:
"Option A (Recommend): 16 GHz scope + 2 probes = $10K/month
             (meets exact need, available now)

Option B (Alternative): 20 GHz scope + 2 probes = $12K/month
             (more bandwidth, future-proof)

Option C (Budget): Need 16 GHz + 1 probe now = $8K/month
             (second probe delayed 2 weeks)

→ For probe purchase: Escalate to Product Group for go/no-go"
```

**Business Value**:
- ✅ Immediately shows all options with real pricing
- ✅ Sales can quote customer instantly
- ✅ Prerequisite dependencies highlighted (don't forget probes!)
- ✅ Escalation pre-analyzed (PG just needs to approve probe buy)
- ✅ Reduces John's research time from 1+ hour to minutes

---

### USE CASE 3: Multi-Location Inventory Search

**Actors**: Sales Rep (US-based), Product Group, Customer (International)

**Scenario**:
- US Customer needs equipment now
- US warehouse doesn't have specific unit
- Available in European warehouse (D365)
- Lead time from Europe acceptable

**Current State**:
1. Sarah searches Perfect (US only)
2. Not found in US
3. Escalates to John
4. John manually checks D365 for Europe
5. Has to contact Belgium/Denmark team for availability
6. Back-and-forth with European team: 1-2 hours
7. Customer waits

**With AI Product Advisor**:

```
Sales Input: "Need RF Spectrum Analyzer, model X-2000, for US customer. 
             Need by Dec 10"
│
AI System:
├─ Priority Search (US warehouses first)
│  └─ Result: Not found in US
├─ User Prompt: "Would you like me to check European locations?"
│  └─ Sales says: "Yes, but only if it can arrive by Dec 10"
├─ Secondary Search (D365 Europe, with lead time calculation)
│  ├─ Denmark warehouse: 1 available
│  ├─ Lead time: 8 days shipping
│  ├─ Can arrive: Dec 8 ✓
│  └─ Cost: Standard rental + shipping fee
└─ Result: "Found in Denmark. Standard rental $X + $Y shipping.
           Available Dec 8. PG approval: contact Belgium team."
```

**Business Rule**:
> "Show TOP 5 results from primary location first. If none, offer to search secondary locations with user permission."

**Business Value**:
- ✅ Intelligent geographic prioritization
- ✅ Lead time calculations built in
- ✅ Avoids searching Europe if customer needs same-day
- ✅ Pre-calculates "will it work?" before escalating

---

## Business Rules & Escalation Triggers

### The "10 Commandments" for AI System

**Rules for When to DEFER to Product Group**:

1. **Incomplete Customer Requirements**
   - Trigger: Customer can't specify bandwidth OR power rating OR compatibility
   - Action: Ask clarifying questions, then escalate if still unclear

2. **Complex Configuration Dependencies**
   - Trigger: Equipment needs multiple add-ons/probes/software with interdependencies
   - Action: Show prerequisites, but escalate for PG judgment on purchasing

3. **Buy-Vs-Substitute Decision Required**
   - Trigger: Exact equipment not in stock, decision between: buy new, wait for repair, substitute
   - Action: Present options with leads times/costs, PG makes final call

4. **Inventory Status Ambiguity**
   - Trigger: Unit status = "in repair" or "amber" (unclear availability)
   - Action: Flag for PG verification before quoting

5. **Price/Margin Judgment Needed**
   - Trigger: Customer on budget, but best option is expensive/over-optioned
   - Action: Present trade-offs, PG decides on pricing strategy

6. **Vendor/Supplier Coordination Required**
   - Trigger: Lead time > 4 weeks, or requires special order from supplier
   - Action: Escalate with all info gathered, PG contacts supplier

7. **Brand/Referral Preferences Protected**
   - Trigger: Referral from competitor or brand preference expressed
   - Action: Respect preference, don't auto-substitute different brand

8. **New Product Category / Low Confidence**
   - Trigger: Product category AI hasn't seen many examples of
   - Action: Show confidence level ("I'm 45% confident"), recommend escalation

9. **System Data Freshness Issue**
   - Trigger: Data >30 days old (pricing/availability)
   - Action: Flag with warning, suggest verifying with PG

10. **Customer Relationship Risk**
    - Trigger: High-value customer, complex need, relationship at stake
    - Action: Escalate immediately to preserve relationship

---

## Key Data Points the System Needs

### From Perfect Inventory System:
- Equipment model number and description
- Real-time availability status (available, in repair, broken, on order)
- Lead time change date (indicates last price update)
- Unit status codes (amber = unclear status)
- Configuration/option codes
- Software license options available

### From D365 (European Inventory):
- Availability in other regions
- Shipping lead times
- Regional pricing variations

### From Salesforce/ERP:
- Customer rental history
- Previous substitution decisions (for learning)
- Referral/brand preference history

### Pricing Data:
- 30-day rental rate
- List price (for reference)
- Depreciation tracking (for sales decisions)
- Add-on pricing (probes, cables, software licenses)
- Price last updated date (freshness indicator)

### Product/Technical Data:
- Specification sheets (PDF library)
- Feature interdependency rules
- Configuration matrices
- Compatible accessory lists
- Software compatibility matrix

---

## Pricing Awareness & Transparency

### Critical Rule
> **"ALL PRICING MUST BE REAL-TIME FROM PERFECT. Never use historical pricing from chat history. If pricing is >30 days old, flag it with a warning."**

### Pricing Display Strategy

```
Equipment Recommendation Card:
┌─────────────────────────────────────────┐
│ Keysight UXR 16 GHz Oscilloscope        │
├─────────────────────────────────────────┤
│ Specifications: 16 GHz bandwidth,       │
│                 4-channel, 256 Mpts     │
│                                          │
│ Availability: 2 units available NOW     │
│ Location: Denver warehouse              │
│                                          │
│ Pricing:                                 │
│  • 30-day rental: $8,500                 │
│  • List price: $425,000                  │
│  • Last price updated: 11/04/2025 ✓      │
│                                          │
│ Required Accessories:                    │
│  • Probe set (1): Included              │
│  • Probe set (2): +$2,000/month         │
│  ⚠️  Second probe on backorder (ETA TBD) │
│                                          │
│ Alternatives:                            │
│  • 20 GHz model: $10,500/mo (more $$$)  │
│  • 10 GHz model: $6,500/mo (less BW)    │
│                                          │
│ Action: [ Quote ] [ Ask PG ] [ More ]   │
└─────────────────────────────────────────┘
```

### Follow-Up Questions AI Should Ask

**For Oscilloscopes**:
- What bandwidth do you need? (Key spec)
- How many channels? (Key spec)
- What sampling rate? (Often forgotten but critical)
- Do you need probes? (Prerequisite dependency)
- How many probes? (Follow-up to above)
- Specific brand preference? (Keysight/Tektronix/Rohde & Schwarz)

**For Power Supplies**:
- Voltage requirements? (Key spec)
- Current requirements? (Key spec)
- Do you need 4-quadrant capability? (Advanced feature)
- DC only or AC+DC? (Key spec)
- Do you need remote control? (Optional)

**For RF Spectrum Analyzers**:
- Frequency range needed? (Key spec)
- Resolution bandwidth? (Advanced)
- Real-time spectrum analysis needed? (Advanced)
- Do you need a preamplifier? (Accessory dependency)
- Where will it be deployed? (Lab vs. field affects choices)

---

## Success Metrics & Measurement

### Response Time Impact
| Metric | Before | Target | Improvement |
|--------|--------|--------|------------|
| Type 1 Query (Part Number) | 15 min | 2 min | **87% faster** |
| Type 2 Query (Application) | 45 min | 5 min | **89% faster** |
| Type 3 Query (Problem) | 2 hours | 15 min escalation | **87% faster** |
| Average Response | 45 min | 5-10 min | **85% faster** |

### Escalation Reduction
| Scenario | Before | After | Reduction |
|----------|--------|-------|-----------|
| Part Number Known | 20% escalation | 10% escalation | 50% reduction |
| Application Type | 60% escalation | 40% escalation | 33% reduction |
| Problem Vague | 85% escalation | 85% escalation | 0% (refers to AE) |
| **Overall** | **40-60/day** | **12-18/day** | **70% reduction** |

### Customer Experience Metrics
- Win rate improvement: 65-70% → 80-85% (+15-20%)
- Quote-to-order time: 2-3 weeks → 3-5 days (75% faster)
- Sales confidence in recommendations: TBD baseline
- Customer satisfaction with response time: TBD baseline

### Quality Metrics
- Recommendation accuracy: Track if sales uses AI recommendation vs. asks for different option
- Pricing accuracy: No outdated prices quoted
- Escalation appropriateness: Was escalation actually needed?
- False confidence: System said "I'm 90% confident" but recommendation was wrong

---

## Implementation Priorities

### Phase 1: MVP (Q4 2025)
✅ Oscilloscopes  
✅ RF Spectrum Analyzers  
✅ Telecom Transmission Testers  
**Focus**: Common part-number lookups + basic application matching

### Phase 2: Pilot (Q1 2026)
✅ All remaining product categories  
✅ Refined escalation rules  
✅ Historical data learning  
**Focus**: Cross-category recommendations + advanced filtering

### Phase 3: Enhancement (Q2 2026+)
✅ Overdue invoice detection  
✅ Calibration tracking  
✅ Runaway rental alerts  
✅ Customer-facing interface  
**Focus**: Predictive insights + proactive outreach

---

## Questions AI System Should Prompt Users With

### By Product Category

**Oscilloscope Category**:
1. What's the primary measurement application? (digital design, power analysis, microwave, etc.)
2. What bandwidth do you need?
3. How many channels?
4. What sampling rate would you need?
5. Do you need any probes? (Most do)
6. How many probe sets?
7. Brand preference? (Keysight/Tek/R&S, or don't care?)

**Power Supply Category**:
1. What's your primary application?
2. DC or AC+DC capability?
3. Voltage range needed?
4. Current rating needed?
5. Do you need 4-quadrant operation?
6. Remote programming capability needed?
7. Any specific brand required?

**RF Spectrum Analyzer Category**:
1. What's the primary measurement type?
2. Frequency range needed?
3. Will this be lab-based or field portable?
4. Do you need real-time spectrum capability?
5. Do you need a preamplifier?
6. Any brand preference?

---

## Appendix: Product Taxonomy

### ElectroRent Product Hierarchy

```
Segment
  ↓
Class
  ↓
Part Family (e.g., "UXR" for Keysight high-end scope)
  ↓
Model (e.g., "UXR-33GHz")
  ↓
Part Number
  ↓
Asset/Serial Number (individual unit)
```

### Example: Keysight UXR Oscilloscope

```
Segment: Electronic Test Equipment
  Class: Oscilloscopes
    Family: UXR (High-end digital scope)
      Model: UXR-16GHz (16 GHz bandwidth version)
        Part: 123-4567-01
          Asset: KEYX-UXR-0045 (Serial number)
```

This hierarchy allows the AI to:
- Recommend alternatives at any level (same family, different model, different class)
- Understand compatibility rules (which probes work with which scope family)
- Make substitution recommendations based on hierarchy proximity

---

## Document Evolution

| Version | Date | Changes | Owner |
|---------|------|---------|-------|
| 1.0 | Nov 2025 | Initial 8 use cases | AI Team |
| 2.0 | Nov 2025 | Enhanced with discovery calls, real examples, rules | Sergio |
| 2.1 | TBD | Stakeholder feedback | Paul/Stan |
| 3.0 | TBD | Final approved version | Business Owner |

---

**Last Updated**: November 2025  
**Status**: Ready for Stakeholder Review  
**Next Review**: After stakeholder feedback (Call #2)  
**Owner**: Ted Skinner / AI Product Advisor Team

