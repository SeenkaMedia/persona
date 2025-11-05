# PERSONA - Project Milestones & Presentation Structure

## Overview
This document structures the Persona project into 3 major milestones that serve both as:
1. **Presentation sections** for stakeholder alignment
2. **Project management milestones** for tracking progress

Each milestone answers specific stakeholder questions and delivers measurable value.

---

## Milestone 1: Foundation & Proof of Concept
**Duration:** 8-10 weeks
**Theme:** "Can we do this without getting caught?"

### Stakeholder Value
De-risks the biggest technical and operational unknowns:
- ✅ Proves we can avoid platform detection
- ✅ Establishes baseline infrastructure costs
- ✅ Validates integration with existing systems
- ✅ Demonstrates feasibility to secure further investment

### Core Deliverables

#### Infrastructure (Week 1-2)
- GKE cluster with persona containers
- PostgreSQL (personas, devices, accounts, households)
- Firestore (activities, behavioral state)
- GCS buckets (screenshots, profiles, cookies)
- PubSub topics (activity commands, events)

#### Integration with Existing Systems (Week 2-3)
- **Account Management**: Pull from Media Service API, maintain persistent persona bindings
- **Proxy Infrastructure**: Reuse scraping's Elasticsearch proxy pool with household "sticky" assignment
- **Storage**: Separate GCS bucket structure (gs://persona-profiles/)
- **Code Reuse**: Import scraping utilities as git submodule

#### Single-Platform Automation (Week 3-6)
- TikTok container with Selenium/Puppeteer + stealth
- Atomic actions library (scroll, click, type, watch)
- Basic behavioral primitives (browse feed, watch video)
- Ad detection and screenshot capture
- Cookie/profile persistence per device

#### Anti-Detection Basics (Week 5-7)
- Commercial proxy integration (OxyLabs via scraping infrastructure)
- Device fingerprint generation (browser, canvas, WebGL)
- Rate limiting logic
- Human-like timing patterns

#### Monitoring Foundation (Week 7-8)
- Container health monitoring
- Basic activity logging
- Detection event tracking
- Cost metrics dashboard (Grafana)

#### Validation & Testing (Week 9-10)
- Run 5-10 test personas continuously
- Measure detection rates over 2+ weeks
- Document cost per persona (compute, proxy, storage)
- Refine based on learnings

### Success Metrics
- **Detection Avoidance**: 5-10 personas run for 14+ days without account suspension
- **Ad Capture**: >30 TikTok ads per persona per day
- **Cost Baseline**: Document cost per persona per month (target: < $50)
- **Integration**: Successful connection to all shared infrastructure (proxies, accounts, storage)

### Key Stakeholder Questions Answered
1. **Can we avoid detection?** → Yes, personas survive X weeks at Y% detection rate
2. **What does it cost?** → $Z per persona per month at MVP scale
3. **Does it integrate cleanly?** → Yes, reuses proxies/accounts/storage without conflicts
4. **Is the data quality good?** → Yes, capturing complete ad screenshots with metadata

### Risks & Mitigations
| Risk | Mitigation |
|------|-----------|
| High detection rate | Extensive anti-detection research, behavioral realism iteration |
| Proxy costs too high | Evaluate alternative providers, custom proxy network roadmap |
| Integration conflicts | Early coordination with scraping team, separate namespaces |
| Scope creep | Strict TikTok-only focus, defer multi-platform |

---

## Milestone 2: Core Product & Intelligence
**Duration:** 10-12 weeks
**Theme:** "The crown jewels - what makes this valuable"

### Stakeholder Value
Delivers the differentiated capabilities that generate business value:
- ✅ Non-technical stakeholders can monitor and control personas
- ✅ Personas behave realistically across multiple platforms
- ✅ System extracts actionable advertising intelligence
- ✅ Demonstrates clear ROI for client pitches

### Core Deliverables

#### AI Behavior Management (Week 1-4)
- **Narrative Generation**:
  - LLM integration (GPT-4 or Claude API)
  - Prompt engineering for realistic daily activity plans
  - Persona profile → narrative mapping
  - Validation logic (realistic timing, platform limits)
- **Behavioral Scheduler**:
  - Convert narratives to executable activity plans
  - Time-based triggers with human-like variation
  - Cross-platform activity coordination
- **Learning & Evolution**:
  - Interest graph updates based on activities
  - Persona behavioral pattern tracking
  - Narrative refinement from historical performance

#### Multi-Platform Expansion (Week 2-6)
- **Instagram Automation**:
  - Feed browsing, Stories, Reels
  - Ad detection (feed, Stories, Explore)
  - Engagement primitives (like, comment, follow)
- **YouTube Automation**:
  - Video watching with realistic completion rates
  - Ad detection (pre-roll, mid-roll, display)
  - Search and recommendation following
- **Facebook Automation** (Basic):
  - Feed browsing
  - Ad detection (feed, sidebar)
  - Minimal engagement
- **Platform-Specific Adaptations**:
  - Different behavioral patterns per platform
  - Platform-specific rate limits
  - Ad format detection variations

#### Cross-Platform Coherence (Week 4-8)
- **Consistent Identity**:
  - Same interests reflected across platforms
  - Realistic engagement level variations (power user on Instagram, casual on Facebook)
  - Search/content correlations (see ad on TikTok → search on YouTube)
- **Device Switching**:
  - Mobile usage patterns (morning/evening, on-the-go)
  - Desktop usage patterns (work hours, deep browsing)
  - Realistic transitions between devices
- **Household Coordination**:
  - Multiple personas sharing same residential IP
  - Realistic usage patterns (not all active simultaneously)
  - Shared device simulation (family desktop, smart TV)

#### User-Friendly Dashboard (Week 5-10)
- **Live Monitoring View**:
  - "Glass pane laboratory" - see all personas' current activities
  - Real-time activity feed
  - Container status indicators
  - Detection alerts
- **Persona Configuration UI**:
  - Create/edit persona profiles (demographics, interests)
  - Configure devices and households
  - Set activity schedules and patterns
  - Pause/resume/restart personas
- **Ad Intelligence Gallery**:
  - Browse captured ads with filters (platform, date, persona, advertiser)
  - Full-screen ad viewer with metadata
  - Targeting analysis view (which personas saw which ads)
  - Export capabilities (CSV, reports)
- **Remote Takeover**:
  - VNC access to persona containers for debugging
  - Manual control mode for testing
  - Activity replay viewer
- **Analytics Integration**:
  - Grafana dashboards for metrics
  - Ad exposure trends
  - Persona performance leaderboard
  - Detection incident tracking

#### Advanced Anti-Detection (Week 6-9)
- **Behavioral Realism**:
  - Human imperfections (missed clicks, typos, distractions)
  - Time-of-day energy levels (slower at night, faster in morning)
  - Occasional breaks and offline periods
  - Realistic session lengths with variation
- **Fingerprint Sophistication**:
  - Mobile device emulation (Appium + Android/iOS)
  - Canvas/WebGL fingerprint noise
  - Audio fingerprint spoofing
  - Font enumeration control
- **Detection Response**:
  - Automated CAPTCHA detection and alerting
  - Graceful degradation on rate limits
  - Proxy rotation on IP blocks
  - Account cooldown strategies

#### Content Intelligence (Week 9-12)
- **Ad Targeting Analysis**:
  - Extract targeting signals from ad exposure patterns
  - Persona demographic → ad correlation
  - Competitive intelligence (which brands target which audiences)
  - Ad creative trend analysis
- **Elasticsearch Integration**:
  - Full-text search of captured ad content
  - Ad similarity detection
  - Brand/product category classification
  - Temporal trend queries
- **BigQuery Analytics**:
  - Time-series ad exposure data
  - Cross-platform ad frequency
  - Persona engagement metrics
  - Client reporting queries

### Success Metrics
- **Multi-Platform Coverage**: Personas active on 3+ platforms simultaneously
- **Behavioral Realism**: AI narratives pass human review 90%+ of time
- **Ad Capture Volume**: >100 ads per persona per day across all platforms
- **Detection Rate**: <3% of personas flagged per month
- **Stakeholder Usability**: Non-technical users can configure personas and view insights without developer help
- **Dashboard Adoption**: Dashboard used for 80%+ of monitoring tasks (vs manual log inspection)

### Key Stakeholder Questions Answered
1. **Can stakeholders use it?** → Yes, intuitive dashboard requires no technical knowledge
2. **Is behavior realistic?** → Yes, personas pass as real users across platforms
3. **What intelligence do we extract?** → Ad targeting patterns, competitive insights, trend analysis
4. **What's the ROI?** → X actionable insights per month, Y% better ad targeting understanding vs manual research

### Risks & Mitigations
| Risk | Mitigation |
|------|-----------|
| AI narratives unrealistic | Extensive prompt engineering, validation logic, human review loop |
| Dashboard complexity | User testing with non-technical stakeholders, iterative UX refinement |
| Multi-platform detection | Platform-specific anti-detection tuning, graceful degradation |
| High LLM costs | Prompt optimization, caching, cheaper models for routine tasks |

---

## Milestone 3: Scale & Production Operations
**Duration:** 8-10 weeks
**Theme:** "Can we run this as a business?"

### Stakeholder Value
Proves operational sustainability and business scalability:
- ✅ System supports client-facing operations at scale
- ✅ Costs are predictable and profitable
- ✅ Minimal developer intervention required
- ✅ Ready for client onboarding

### Core Deliverables

#### Scale Infrastructure (Week 1-3)
- **Kubernetes Optimization**:
  - Autoscaling policies for persona containers
  - Resource limits tuning (CPU, memory)
  - Pod anti-affinity rules (distribute personas across nodes)
  - Health checks and auto-restart
- **Database Optimization**:
  - PostgreSQL indexing and query optimization
  - Firestore collection partitioning
  - BigQuery table partitioning by date
  - Connection pooling and caching
- **Container Orchestration**:
  - Efficient image builds (multi-stage Docker)
  - Image caching strategies
  - Startup time optimization
  - Graceful shutdown handling

#### Cost Optimization (Week 2-4)
- **Compute Efficiency**:
  - Preemptible/Spot instances for non-critical containers
  - Container resource right-sizing
  - Headless browser mode vs VNC overhead
  - Activity batching to reduce idle time
- **Storage Efficiency**:
  - Screenshot compression optimization
  - GCS lifecycle policies (auto-delete old data)
  - Firestore document size optimization
  - Selective capture rules (don't save everything)
- **Proxy Cost Management**:
  - Proxy usage monitoring and optimization
  - Evaluate alternative providers vs custom network
  - Household IP sharing to reduce connections
  - Activity scheduling to avoid peak pricing
- **LLM Cost Management**:
  - Narrative caching (reuse similar plans)
  - Use cheaper models for routine tasks (GPT-3.5 vs GPT-4)
  - Batch API requests
  - Prompt length optimization

#### Scale to 50+ Personas (Week 3-6)
- **Persona Variety**:
  - Create diverse demographic profiles
  - Geographic distribution (multiple countries)
  - Interest variety (ensure broad coverage)
  - Household groupings (families, roommates)
- **Load Testing**:
  - Gradually increase from 20 → 50 personas
  - Monitor detection rates at scale
  - Identify bottlenecks (database, proxies, containers)
  - Stress test dashboard performance
- **Data Volume Management**:
  - Handle 5000+ ads per day
  - Ensure search performance (Elasticsearch)
  - Analytics query performance (BigQuery)
  - Storage growth projections

#### Integration with Business Processes (Week 4-7)
- **Existing Grafana Dashboards**:
  - Add persona metrics to existing monitoring
  - Unified view of scraping + persona systems
  - Cost tracking across all systems
  - SLA monitoring
- **Client Reporting Workflows**:
  - Automated weekly reports (ad exposure, insights)
  - Custom report builder in dashboard
  - API endpoints for external reporting tools
  - Data export formats (CSV, JSON, PDF)
- **Data Pipeline Integration**:
  - Persona data flows into existing analytics
  - Cross-reference persona ads with scraping ads
  - Unified ad intelligence database
  - Client-facing API for ad data access

#### Operational Excellence (Week 5-8)
- **Monitoring & Alerting**:
  - Prometheus metrics collection
  - Grafana dashboards (system health, persona status, cost tracking)
  - PagerDuty/Slack alerts for critical issues:
    - Detection events
    - Container failures
    - Cost threshold breaches
    - Proxy exhaustion
  - Automated health checks
- **Automated Recovery**:
  - Self-healing containers (auto-restart on failure)
  - Proxy rotation on detection
  - Account cooldown and rotation
  - Narrative regeneration on validation failures
- **Backup & Disaster Recovery**:
  - PostgreSQL automated backups
  - Firestore export schedules
  - GCS bucket versioning
  - Recovery runbooks
- **Documentation**:
  - Operational runbook (common issues, resolutions)
  - Architecture diagrams (updated)
  - API documentation (Swagger/OpenAPI)
  - Onboarding guide for new team members

#### Advanced Features (Week 7-10)
- **Household/Family Simulation**:
  - Realistic family relationships (parents, children, siblings)
  - Shared device usage patterns
  - Cross-persona influence (family members share interests)
  - Household events (birthdays, holidays affect behavior)
- **GPS Transitions** (If Required):
  - Realistic travel between locations
  - Commute patterns (home ↔ work)
  - Speed limits on roads (no teleporting)
  - Location-based activity (work apps at work, home apps at home)
- **Physical Device Farm Evaluation**:
  - ROI analysis (when does real hardware make sense?)
  - Vendor research (device farms, procurement)
  - Pilot program design (5-10 real devices)
  - Hybrid architecture (virtual + physical)

### Success Metrics
- **Scale**: 50+ personas running reliably 24/7
- **Detection Rate**: <2% at scale (better than MVP due to learnings)
- **Cost Efficiency**: < $40 per persona per month (20% reduction from MVP)
- **Uptime**: 99%+ container uptime
- **Recovery**: <5 min automated recovery from failures
- **Operational Load**: <2 hours/week developer intervention
- **Client Readiness**: 3+ client pilot programs launched

### Key Stakeholder Questions Answered
1. **Can we scale?** → Yes, 50+ personas without infrastructure issues
2. **Is it profitable?** → Yes, cost per persona is $X, client value is $Y (Y > X)
3. **Can we operate it?** → Yes, <2 hours/week maintenance, automated recovery
4. **Are we ready for clients?** → Yes, dashboard + reporting + API ready for client onboarding

### Risks & Mitigations
| Risk | Mitigation |
|------|-----------|
| Detection rate increases at scale | Behavioral diversity, rate limit tuning, proxy pool expansion |
| Costs don't decrease enough | Aggressive optimization, custom proxy network, selective capture |
| Operational complexity | Extensive automation, runbook documentation, team training |
| Client expectations mismatch | Early pilot programs, clear SLA definitions, expectation management |

---

## Cross-Cutting Themes

### Architectural Decisions (Milestone 1)
These decisions inform all subsequent work:

1. **Account Management**: Pull from Media Service API, maintain persona → account binding in PostgreSQL
2. **Cookie/Profile Storage**: Separate GCS bucket (gs://persona-profiles/)
3. **Proxy Management**: Reuse scraping's Elasticsearch pool with sticky household assignment
4. **Elasticsearch Usage**: Shared cluster, separate indices (persona-ads-*)
5. **Ad Storage**: Separate Firestore collection (persona-ads)
6. **Code Reuse**: Import scraping utilities as git submodule
7. **Behavior Orchestration**: Monolithic FastAPI backend initially, extract to microservice later if needed

### Technology Stack Summary
- **Backend**: Python 3.11+ (FastAPI, Celery), TypeScript (API gateway)
- **Frontend**: Angular 17+, Tailwind CSS
- **Automation**: Playwright (web), Appium (mobile)
- **Infrastructure**: GKE, PostgreSQL, Firestore, BigQuery, GCS, Elasticsearch, PubSub
- **AI**: OpenAI API or Anthropic Claude API
- **Monitoring**: Prometheus, Grafana, Cloud Logging

### Resource Requirements

#### Team (Per Milestone)
- **Milestone 1**: 1 senior backend dev (you), 0.5 junior dev (integration support)
- **Milestone 2**: 1 senior backend dev, 1 frontend dev, 0.5 DevOps
- **Milestone 3**: 1 senior backend dev, 0.5 frontend dev, 0.5 DevOps, 0.5 PM (client onboarding)

#### Infrastructure Costs (Monthly, Projected)
- **Milestone 1 (10 personas)**:
  - Compute (GKE): $300
  - Storage (GCS, PostgreSQL, Firestore): $100
  - Proxies (OxyLabs): $500
  - **Total: ~$900/month**

- **Milestone 2 (20 personas)**:
  - Compute (GKE): $600
  - Storage: $200
  - Proxies: $1000
  - LLM API (narratives): $200
  - **Total: ~$2000/month**

- **Milestone 3 (50 personas)**:
  - Compute (GKE): $1200
  - Storage: $400
  - Proxies: $2000
  - LLM API: $300
  - **Total: ~$3900/month** → **$78/persona/month**

---

## Success Criteria Rollup

| Milestone | Primary Success Metric | Timeline |
|-----------|----------------------|----------|
| **1: Foundation** | 10 personas survive 14+ days without detection | 8-10 weeks |
| **2: Core Product** | Non-technical stakeholders can operate system, 100+ ads/persona/day | 10-12 weeks |
| **3: Scale & Ops** | 50+ personas at <$80/persona/month, <2 hrs/week maintenance | 8-10 weeks |

**Total Timeline: 26-32 weeks (~6-8 months)**

---

## Next Steps

1. **Stakeholder Presentation**: Use this document structure for presentation slides
2. **Decision Approval**: Get sign-off on 7 architectural decisions (Milestone 1)
3. **Resource Allocation**: Confirm team availability and budget
4. **Kick-off**: Begin Milestone 1 work
