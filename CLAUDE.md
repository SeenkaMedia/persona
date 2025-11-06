# PERSONA - Digital Identity Simulation System

## Project Overview

**Persona** is a comprehensive ecosystem for maintaining and simulating realistic social media profiles for media monitoring and competitive intelligence. The system creates and manages digital personas that behave like real users across multiple platforms, devices, and contexts to capture advertising data and content insights while maintaining authenticity and avoiding detection.

### Core Objectives

1. **Ad Intelligence**: Capture and analyze advertisements across social media platforms (TikTok, Instagram, Facebook, YouTube)
2. **Realistic Simulation**: Create believable digital footprints through authentic browsing patterns, device switching, and behavioral coherence
3. **Scalability**: Start with ~20 high-fidelity personas, expandable to hundreds
4. **Cross-Platform Coherence**: Maintain consistent identity and behavior across platforms and devices
5. **Anti-Detection**: Avoid platform detection through sophisticated fingerprinting, timing, and behavioral variation
6. **Stakeholder Visibility**: Provide intuitive dashboards for monitoring and demonstrating system capabilities

### Use Case

Media monitoring company tracking how advertising algorithms target different demographic profiles. Legal gray area (platforms prohibit scraping) but with plausible deniability - creating realistic user simulations for research purposes, not manipulating engagement or reselling data directly.

---

## System Architecture

### High-Level Design Philosophy

**Stateless Compute + Stateful Persistence + Event-Driven Communication**

- **Containers** = Ephemeral execution environments (can spin up/down)
- **Persona State** = Persistent identity stored in databases (cumulative, long-term)
- **PubSub** = Communication backbone between components (event-driven, reliable)

```
┌─────────────────────────────────────────────────────────────┐
│                     PERSONA SYSTEM                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐   │
│  │   Persona    │    │   Persona    │    │   Persona    │   │
│  │ Container 1  │    │ Container 2  │    │ Container N  │   │
│  │              │    │              │    │              │   │
│  │ ┌──────────┐ │    │ ┌──────────┐ │    │ ┌──────────┐ │   │
│  │ │ Browser  │ │    │ │ Mobile   │ │    │ │ Browser  │ │   │
│  │ │ Automation││    │ │ Emulator │ │    │ │ Automation││   │
│  │ └──────────┘ │    │ └──────────┘ │    │ └──────────┘ │   │
│  └──────┬───────┘    └──────┬───────┘    └──────┬───────┘   │
│         │                   │                   │           │
│         └───────────────────┼───────────────────┘           │
│                             │                               │
│  ┌──────────────────────────▼──────────────────────────┐    │
│  │           BEHAVIOR ORCHESTRATOR                     │    │
│  │  ┌─────────────┐  ┌──────────────┐  ┌────────────┐  │    │
│  │  │ AI Planner  │  │  Scheduler   │  │  Monitor   │  │    │
│  │  └─────────────┘  └──────────────┘  └────────────┘  │    │
│  └──────────────────────────▲──────────────────────────┘    │
│                             │                               │
│  ┌──────────────────────────▼──────────────────────────┐    │
│  │              PUBSUB MESSAGE BUS                     │    │
│  │         (Events, Commands, State Updates)           │    │
│  └──────────────────────────▲──────────────────────────┘    │
│                             │                               │
│  ┌──────────────────────────▼──────────────────────────┐    │
│  │              STATE PERSISTENCE LAYER                │    │
│  │                                                     │    │
│  │  ┌──────────┐ ┌───────────┐ ┌──────────┐ ┌───────┐  │    │
│  │  │PostgreSQL│ │  Firestore│ │BigQuery  │ │  GCS  │  │    │
│  │  │(Identity)│ │(Behavior) │ │(Analytics)│ │(Blobs)│ │    │
│  │  └──────────┘ └───────────┘ └──────────┘ └───────┘  │    │
│  │                                                     │    │
│  │  ┌───────────────────────────────────────────────┐  │    │
│  │  │        Elasticsearch (Content Search)         │  │    │
│  │  └───────────────────────────────────────────────┘  │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              DASHBOARD & ADMIN UI                    │   │
│  │  (Angular Frontend - Live View, Configuration)       │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Component Breakdown

#### 1. Persona Containers
- **Purpose**: Isolated execution environment for each persona's activities
- **Technology**: Docker containers running on GKE (Google Kubernetes Engine)
- **Contents**:
  - Browser automation (Puppeteer/Playwright with stealth plugins)
  - Mobile emulator (Appium with Android/iOS emulation)
  - Device fingerprint spoofing
  - Proxy configuration
  - VNC server for remote viewing/control
- **Lifecycle**: Stateless - can be destroyed and recreated, loads persona state on startup

#### 2. Behavior Orchestrator
- **Purpose**: Central brain that coordinates persona activities
- **Components**:
  - **AI Planner**: Generates high-level activity narratives based on persona profile
  - **Scheduler**: Converts narratives to timed execution plans
  - **Monitor**: Validates actions, detects anomalies, handles failures
- **Language**: Python (primary logic) + TypeScript (API layer)

#### 3. PubSub Message Bus
- **Purpose**: Event-driven communication between all components
- **Use Cases**:
  - Activity commands (Container X: execute behavior Y)
  - State updates (Persona A completed action B)
  - Data capture events (Ad screenshot saved to GCS)
  - System monitoring (Container health, errors, metrics)
- **Technology**: Google Cloud Pub/Sub (existing infrastructure)

#### 4. State Persistence Layer

**Hybrid Storage Strategy:**

**PostgreSQL (Structured, Relational Data)**
- Personas (identity, demographics, metadata)
- Households (shared resources, relationships)
- Devices (fingerprints, configurations)
- Accounts (platform credentials, status)

**Firestore/MongoDB (Flexible, High-Write Documents)**
- Activity history (every action taken)
- Interest graphs (evolving preferences)
- Behavioral patterns (learned habits)
- Session state (current context)

**BigQuery (Time-Series Analytics)**
- Behavioral metrics aggregated over time
- Ad exposure analytics
- Platform engagement statistics
- Cross-persona insights

**Google Cloud Storage (Blob Data)**
- Screenshots (ads, content)
- Screen recordings
- Raw HTML/JSON captures
- Training data for AI models

**Elasticsearch (Existing Infrastructure)**
- Full-text search of captured content
- Ad targeting analysis
- Content discovery and categorization

**Event Sourcing Pattern (Included)**
- Every action is an immutable event stored chronologically
- Persona state can be reconstructed by replaying events
- Perfect audit trail for debugging and compliance
- Events published to PubSub, persisted to Firestore + BigQuery

#### 5. Dashboard & Admin UI
- **Purpose**: Monitor personas, configure behaviors, review captured data
- **Technology**: Angular frontend
- **Features**:
  - Live view of persona activities (glass-pane laboratory view)
  - Persona configuration (demographics, interests, schedules)
  - Ad capture gallery (browse collected ads)
  - Remote control takeover (VNC access to containers)
  - Activity logs and system health
  - Analytics integration (Grafana dashboards for metrics)

---

## Core Data Models

### Persona

```python
class Persona:
    # Identity (Fixed/Rare Changes)
    id: UUID
    name: str
    date_of_birth: date
    gender: str
    location_home: GeoCoordinates
    location_work: GeoCoordinates  # Optional
    education: List[EducationRecord]
    work_history: List[WorkRecord]
    household_id: UUID  # Optional - links to shared resources
    
    # Demographics (Template-Based)
    income_bracket: str
    relationship_status: str
    has_children: bool
    language_preferences: List[str]
    
    # Behavioral Profile (AI-Generated + Evolving)
    interest_graph: Dict[str, float]  # topic -> interest_score
    personality_traits: Dict[str, float]  # openness, conscientiousness, etc.
    media_preferences: Dict[str, Any]  # platform usage, content types
    activity_patterns: Dict[str, Any]  # when active, session lengths
    
    # Device Ownership
    devices: List[DeviceID]  # mobile, desktop, OTT
    
    # Platform Accounts
    accounts: Dict[Platform, AccountID]  # TikTok, Instagram, etc.
    
    # State References
    created_at: datetime
    last_active: datetime
    status: PersonaStatus  # active, paused, suspended
    
    # Metadata
    tags: List[str]  # for organization/filtering
    notes: str  # human-readable context
```

### Household

```python
class Household:
    # Shared Resources
    id: UUID
    name: str
    location: GeoCoordinates
    timezone: str
    
    # Shared Devices
    shared_desktop_fingerprint: DeviceFingerprint
    shared_ott_device: DeviceFingerprint  # Smart TV, Roku, etc.
    
    # Network
    residential_proxy: ProxyConfig  # Shared IP address
    isp_info: ISPInfo  # Realistic ISP assignment
    
    # Members
    persona_ids: List[UUID]  # Personas in this household
    
    # Relationships (Optional - for realistic cross-persona interactions)
    relationships: Dict[UUID, RelationType]  # parent, sibling, spouse, etc.
    
    # Behavioral Coherence
    shared_interests: List[str]  # Topics all members might know about
    household_events: List[Event]  # Birthdays, holidays, etc.
```

### Device

```python
class Device:
    id: UUID
    persona_id: UUID
    device_type: DeviceType  # mobile, desktop, tablet, ott
    
    # Fingerprint Components
    user_agent: str
    screen_resolution: Tuple[int, int]
    timezone: str
    language: str
    platform: str  # iOS, Android, Windows, macOS
    browser: str  # Chrome, Safari, Firefox
    browser_version: str
    
    # Advanced Fingerprinting
    canvas_fingerprint: str
    webgl_fingerprint: str
    audio_fingerprint: str
    fonts_installed: List[str]
    plugins: List[str]
    hardware_concurrency: int
    device_memory: int
    
    # Mobile-Specific
    mobile_os_version: str  # Optional
    device_model: str  # Optional
    imei: str  # Optional (for real device farms)
    
    # GPS Spoofing
    gps_home: GeoCoordinates
    gps_work: GeoCoordinates  # Optional
    gps_current: GeoCoordinates  # Changes based on activity context
    
    # TODO: GPS Transitions (Phase 2+)
    # - Realistic travel between locations
    # - Speed limits on roads
    # - Commute patterns (morning/evening)
    # - Location-specific activities (work apps at work, home apps at home)
    
    # Network
    proxy_config: ProxyConfig  # Individual or shared (household)
    
    # Status
    last_used: datetime
    active: bool
```

### Activity

```python
class Activity:
    # Event Sourcing Pattern
    id: UUID
    persona_id: UUID
    device_id: UUID
    timestamp: datetime
    
    # Activity Classification
    activity_type: ActivityType  # browse_feed, search, watch_video, etc.
    platform: Platform  # TikTok, Instagram, YouTube, Web, etc.
    
    # Activity Details (JSON - flexible schema)
    details: Dict[str, Any]
    # Examples:
    # - browse_feed: {duration: 600, scrolls: 45, likes: 3, shares: 0}
    # - search: {query: "recipe ideas", results_clicked: 2}
    # - watch_video: {video_id: "xyz", duration: 180, completion: 0.95}
    
    # Outcomes
    success: bool
    error_message: str  # Optional
    
    # Context
    session_id: UUID  # Groups activities in same session
    narrative_id: UUID  # Links to AI-generated plan
    
    # Data Captured
    captured_data_refs: List[str]  # GCS paths to screenshots, HTML, etc.
    
    # Metadata
    execution_time_ms: int  # How long the activity took
    retry_count: int  # If action had to be retried
```

### CapturedAd

```python
class CapturedAd:
    id: UUID
    persona_id: UUID
    device_id: UUID
    activity_id: UUID  # Links to the activity that captured it
    
    # Ad Metadata
    platform: Platform
    ad_format: AdFormat  # image, video, carousel, story, etc.
    timestamp: datetime
    
    # Ad Content
    screenshot_url: str  # GCS path
    video_url: str  # Optional - if video ad
    html_snapshot: str  # Optional - raw HTML
    text_content: str  # Extracted text from ad
    
    # Targeting Analysis (Extracted)
    advertiser: str
    brand: str
    product_category: str
    call_to_action: str
    landing_url: str
    
    # Engagement Tracking
    viewed: bool
    clicked: bool
    engagement_duration: float  # Seconds
    
    # Analysis (Post-Processing)
    targeting_signals: Dict[str, Any]  # Inferred targeting parameters
    similar_ads: List[UUID]  # Links to similar ads
    sentiment: str  # Optional - positive, negative, neutral
    
    # Indexing (Elasticsearch)
    indexed: bool
    search_keywords: List[str]
```

---

## Three-Layer Behavior System

The core innovation of Persona is the separation of concerns between AI planning, behavioral logic, and low-level automation. This makes the system maintainable, testable, and adaptable.

### Layer 1: Atomic Actions (Deterministic, Low-Level)

**Purpose**: Direct interaction with browser/mobile emulator. These are the "muscles" that execute precise movements.

**Characteristics**:
- Platform-specific (Puppeteer for web, Appium for mobile)
- Highly configurable (speed, timing, randomness)
- Error handling and retries
- Validation (did the action succeed?)

**Examples**:

```python
# Web Atomic Actions
async def scroll_feed(page, direction: str, speed: float, duration: int):
    """Scroll through a social media feed"""
    # Add human-like variation
    speed_variation = random.uniform(speed * 0.8, speed * 1.2)
    
    # Scroll in chunks with pauses
    elapsed = 0
    while elapsed < duration:
        scroll_distance = random.randint(300, 800)
        await page.evaluate(f'window.scrollBy(0, {scroll_distance})')
        
        # Random pause (humans don't scroll constantly)
        pause = random.uniform(0.5, 3.0)
        await asyncio.sleep(pause)
        elapsed += pause

async def click_element(page, selector: str, delay: float):
    """Click an element with human-like behavior"""
    element = await page.wait_for_selector(selector)
    
    # Move mouse to element (not instant teleport)
    box = await element.bounding_box()
    # Random point within element bounds
    x = box['x'] + random.uniform(5, box['width'] - 5)
    y = box['y'] + random.uniform(5, box['height'] - 5)
    
    await page.mouse.move(x, y, steps=random.randint(10, 30))
    await asyncio.sleep(random.uniform(0.1, 0.3))
    await page.mouse.click(x, y)
    await asyncio.sleep(delay)

async def type_text(page, selector: str, text: str, typing_speed: float, error_rate: float):
    """Type text with human-like speed and occasional typos"""
    element = await page.wait_for_selector(selector)
    await element.click()
    
    for char in text:
        # Occasional typo
        if random.random() < error_rate:
            # Type wrong character, then backspace
            wrong_char = random.choice('qwertyuiop')
            await page.keyboard.type(wrong_char)
            await asyncio.sleep(random.uniform(0.1, 0.3))
            await page.keyboard.press('Backspace')
        
        await page.keyboard.type(char)
        # Vary typing speed
        await asyncio.sleep(random.uniform(typing_speed * 0.5, typing_speed * 1.5))

async def watch_video(page, selector: str, duration: int, engagement_level: float):
    """Watch a video with realistic engagement patterns"""
    video = await page.wait_for_selector(selector)
    await video.click()  # Start playing
    
    # Engagement determines if we watch fully or skip
    watch_duration = duration * random.uniform(engagement_level, 1.0)
    
    # Occasionally pause/resume
    if random.random() < 0.2:
        await asyncio.sleep(watch_duration * 0.4)
        await video.click()  # Pause
        await asyncio.sleep(random.uniform(1, 5))
        await video.click()  # Resume
        await asyncio.sleep(watch_duration * 0.6)
    else:
        await asyncio.sleep(watch_duration)

# Mobile Atomic Actions
async def swipe(driver, direction: str, distance: int, duration: int):
    """Swipe on mobile device"""
    # Appium touch actions
    # Implementation varies by platform (iOS vs Android)
    pass

async def tap_element(driver, element_id: str):
    """Tap element on mobile"""
    # Find element, tap with realistic touch pressure/duration
    pass
```

**Key Principles**:
- Always add randomness/variation (humans aren't robots)
- Validate action success (element appeared, page loaded, etc.)
- Log everything (for debugging and event sourcing)
- Handle failures gracefully (retry, skip, alert)

### Layer 2: Behavioral Primitives (Composable, Mid-Level)

**Purpose**: Combine atomic actions into meaningful behaviors. These are the "activities" a person does.

**Characteristics**:
- Platform-aware (understands TikTok vs Instagram differences)
- Context-sensitive (adapts based on persona interests)
- Outcome-oriented (achieve a goal, not just execute steps)
- Reusable across personas

**Examples**:

```python
class BehavioralPrimitives:
    
    async def browse_feed(self, persona: Persona, device: Device, duration: int, engagement_rate: float):
        """Browse social media feed for a given duration"""
        page = await self.get_page(device)
        
        # Navigate to feed
        await page.goto(self.get_platform_url(device.current_platform))
        
        # Calculate how many posts to engage with
        estimated_posts_seen = duration / 10  # ~10 seconds per post
        posts_to_engage = int(estimated_posts_seen * engagement_rate)
        
        activities = []
        start_time = time.time()
        
        while time.time() - start_time < duration:
            # Scroll and view content
            await scroll_feed(page, direction='down', speed=1.0, duration=random.randint(5, 15))
            
            # Decide whether to engage with current post
            if posts_to_engage > 0 and random.random() < engagement_rate:
                # Engage based on persona interests
                post_content = await self.extract_post_content(page)
                if self.is_interesting(persona, post_content):
                    # Like, comment, or share
                    engagement_type = self.choose_engagement(persona)
                    await self.engage_with_post(page, engagement_type)
                    posts_to_engage -= 1
                    
                    activities.append({
                        'type': 'engagement',
                        'action': engagement_type,
                        'content': post_content
                    })
            
            # Occasional ad appears
            if await self.detect_ad(page):
                ad_data = await self.capture_ad(page, persona, device)
                activities.append({
                    'type': 'ad_capture',
                    'ad_id': ad_data.id
                })
        
        return activities
    
    async def search_for_topic(self, persona: Persona, device: Device, query: str, exploration_depth: int):
        """Search for a topic and explore results"""
        page = await self.get_page(device)
        
        # Navigate to search
        await page.goto(self.get_search_url(device.current_platform))
        
        # Type search query
        await type_text(page, 'input[type="search"]', query, typing_speed=0.1, error_rate=0.02)
        await page.keyboard.press('Enter')
        
        # Wait for results
        await page.wait_for_selector('.search-results')
        
        # Explore results based on depth
        results_clicked = 0
        for i in range(exploration_depth):
            # Click a result
            result_selector = f'.search-result:nth-child({i+1})'
            await click_element(page, result_selector, delay=1.0)
            
            # Spend time viewing
            viewing_time = random.uniform(10, 60)
            await asyncio.sleep(viewing_time)
            
            # Maybe engage
            if random.random() < 0.3:
                await self.engage_with_content(page, persona)
            
            # Go back to results
            await page.go_back()
            results_clicked += 1
        
        return {
            'query': query,
            'results_clicked': results_clicked,
            'total_time': sum(viewing_times)
        }
    
    async def watch_content(self, persona: Persona, device: Device, category: str, session_length: int):
        """Watch videos/content in a specific category"""
        page = await self.get_page(device)
        
        # Navigate to category or search for it
        await page.goto(self.get_category_url(device.current_platform, category))
        
        videos_watched = 0
        start_time = time.time()
        
        while time.time() - start_time < session_length:
            # Select a video
            video_selector = await self.choose_video(page, persona)
            await click_element(page, video_selector, delay=1.0)
            
            # Get video duration
            video_duration = await self.get_video_duration(page)
            
            # Calculate how much to watch based on interest
            interest_score = self.calculate_interest(persona, category)
            watch_duration = video_duration * random.uniform(interest_score, 1.0)
            
            # Watch video
            await watch_video(page, 'video', duration=watch_duration, engagement_level=interest_score)
            
            # Capture ad if present
            if await self.detect_ad(page):
                await self.capture_ad(page, persona, device)
            
            videos_watched += 1
            
            # Go to next video or back to feed
            if random.random() < 0.7:
                await self.go_to_next_video(page)
            else:
                await page.go_back()
        
        return {
            'category': category,
            'videos_watched': videos_watched,
            'session_length': time.time() - start_time
        }
    
    async def engage_with_ad(self, persona: Persona, device: Device, ad_element, interest_level: float):
        """Interact with an advertisement"""
        # Capture screenshot first
        ad_data = await self.capture_ad_screenshot(ad_element, persona, device)
        
        # Decide on engagement based on interest
        if interest_level > 0.7 and random.random() < 0.3:
            # High interest: click through to advertiser
            await click_element(ad_element, 'a.ad-link', delay=1.0)
            
            # Spend time on advertiser's page
            browse_time = random.uniform(10, 60)
            await asyncio.sleep(browse_time)
            
            # Maybe add to cart or explore more
            if interest_level > 0.9 and random.random() < 0.2:
                # Very interested: deeper exploration
                await self.explore_advertiser_site(persona, device)
            
            await page.go_back()
            
            ad_data.clicked = True
            ad_data.engagement_duration = browse_time
        
        elif interest_level > 0.4 and random.random() < 0.1:
            # Medium interest: hover/view longer
            await page.hover(ad_element)
            await asyncio.sleep(random.uniform(2, 5))
        
        # Save ad data
        await self.save_ad(ad_data)
        
        return ad_data
```

**Key Principles**:
- Each primitive has a clear outcome
- Combines multiple atomic actions
- Adapts to persona's profile (interests, engagement style)
- Returns structured data about what happened
- Publishes events for each meaningful action

### Layer 3: Activity Narratives (AI-Generated, High-Level)

**Purpose**: Generate realistic daily/weekly activity plans that guide what personas do. This is the "brain" that decides behavior.

**Characteristics**:
- Uses persona profile (demographics, interests, habits)
- Generates human-readable plans
- Creates temporal structure (morning, afternoon, evening routines)
- Adapts over time (personas evolve, trends change)

**Examples**:

```python
# AI-Generated Activity Narrative (Prompt to LLM)
def generate_daily_narrative(persona: Persona) -> DailyNarrative:
    """
    Prompt example sent to AI model:
    
    Generate a realistic daily social media activity plan for this persona:
    - Age: 28
    - Gender: Female
    - Location: Austin, TX
    - Occupation: Graphic Designer
    - Interests: Design, fitness, cooking, indie music
    - Platform usage: Instagram (high), TikTok (medium), YouTube (medium)
    - Typical screen time: 2-3 hours/day
    - Activity pattern: Morning scroller, lunch break checker, evening browser
    
    Create a detailed hour-by-hour plan for Monday, including:
    - When they use which platforms and devices
    - What content they search for or browse
    - Approximate engagement levels
    - Realistic breaks and offline time
    """
    
    prompt = self.build_narrative_prompt(persona)
    response = await self.ai_model.generate(prompt)
    
    # AI returns structured JSON:
    return {
        "date": "2025-11-03",
        "persona_id": persona.id,
        "activities": [
            {
                "time": "07:30",
                "device": "mobile",
                "platform": "Instagram",
                "behavior": "browse_feed",
                "duration": 15,
                "engagement_rate": 0.3,
                "context": "Morning coffee, light scrolling through feed",
                "content_interests": ["design inspiration", "fitness motivation"]
            },
            {
                "time": "09:00",
                "device": "desktop",
                "platform": "Web",
                "behavior": "search_for_topic",
                "query": "minimalist logo trends 2025",
                "exploration_depth": 3,
                "context": "Work research for client project"
            },
            {
                "time": "12:30",
                "device": "mobile",
                "platform": "TikTok",
                "behavior": "browse_feed",
                "duration": 20,
                "engagement_rate": 0.5,
                "context": "Lunch break entertainment",
                "content_interests": ["cooking videos", "design hacks"]
            },
            {
                "time": "18:00",
                "device": "mobile",
                "platform": "YouTube",
                "behavior": "watch_content",
                "category": "cooking tutorials",
                "session_length": 45,
                "context": "Evening wind-down, planning dinner"
            },
            {
                "time": "21:00",
                "device": "desktop",
                "platform": "Instagram",
                "behavior": "browse_feed",
                "duration": 30,
                "engagement_rate": 0.4,
                "context": "Evening social check-in, more active engagement"
            }
        ],
        "cross_platform_coherence": {
            "saw_ad_for": "meal kit service",
            "instagram_search": "meal prep ideas",
            "youtube_watch": "meal prep tutorial",
            "context": "Ad exposure influences search and content consumption"
        }
    }

# Translation to Behavioral Primitives
class NarrativeExecutor:
    
    async def execute_narrative(self, narrative: DailyNarrative, persona: Persona):
        """Convert AI narrative into executable behaviors"""
        
        for activity in narrative.activities:
            # Wait until scheduled time
            await self.wait_until(activity.time)
            
            # Load appropriate device
            device = await self.get_device(persona, activity.device)
            
            # Select behavioral primitive based on activity
            if activity.behavior == "browse_feed":
                await self.primitives.browse_feed(
                    persona=persona,
                    device=device,
                    duration=activity.duration * 60,  # Convert to seconds
                    engagement_rate=activity.engagement_rate
                )
            
            elif activity.behavior == "search_for_topic":
                await self.primitives.search_for_topic(
                    persona=persona,
                    device=device,
                    query=activity.query,
                    exploration_depth=activity.exploration_depth
                )
            
            elif activity.behavior == "watch_content":
                await self.primitives.watch_content(
                    persona=persona,
                    device=device,
                    category=activity.category,
                    session_length=activity.session_length * 60
                )
            
            # Log activity completion
            await self.log_activity(persona, device, activity)
            
            # Publish event to PubSub
            await self.publish_event('activity.completed', {
                'persona_id': persona.id,
                'activity': activity.behavior,
                'timestamp': datetime.now()
            })
```

**AI Model Considerations**:
- Use GPT-4 or Claude for narrative generation (better reasoning)
- Fine-tune on real user behavior data if available
- Include constraints (platform ToS limits, realistic timing)
- Validate outputs (does this make sense? is timing realistic?)

**Monitoring & Validation**:
```python
class NarrativeValidator:
    
    def validate_narrative(self, narrative: DailyNarrative, persona: Persona) -> ValidationResult:
        """Ensure AI-generated plan is realistic and safe"""
        
        issues = []
        
        # Check total screen time
        total_duration = sum(a.duration for a in narrative.activities)
        if total_duration > 6 * 60:  # More than 6 hours
            issues.append("Unrealistic total screen time")
        
        # Check activity timing
        prev_time = None
        for activity in narrative.activities:
            if prev_time and (activity.time - prev_time) < 5:  # Less than 5 min between
                issues.append("Activities too close together")
            prev_time = activity.time
        
        # Check for platform rate limits
        platform_usage = {}
        for activity in narrative.activities:
            platform_usage[activity.platform] = platform_usage.get(activity.platform, 0) + 1
        
        for platform, count in platform_usage.items():
            if count > self.get_safe_limit(platform):
                issues.append(f"Too many {platform} sessions")
        
        # Check persona consistency
        for activity in narrative.activities:
            if not self.matches_interests(activity, persona):
                issues.append("Activity inconsistent with persona interests")
        
        return ValidationResult(valid=len(issues) == 0, issues=issues)
```

---

## Anti-Detection Strategy

### Core Principles

1. **Behavioral Realism**: Mimic human patterns, not bot patterns
2. **Fingerprint Diversity**: Each device has unique, consistent fingerprint
3. **Network Authenticity**: Residential proxies, proper ISP data
4. **Temporal Variation**: No perfect timing intervals
5. **Cross-Platform Coherence**: But not identical behavior
6. **Graceful Degradation**: When detection occurs, adapt strategy

### Specific Techniques

#### 1. Browser Fingerprinting

**Puppeteer Stealth Configuration**:
```python
from playwright.async_api import async_playwright
from playwright_stealth import stealth_async

async def create_stealth_browser(device: Device):
    playwright = await async_playwright().start()
    
    browser = await playwright.chromium.launch(
        headless=True,  # Or False for debugging
        args=[
            '--disable-blink-features=AutomationControlled',
            '--no-sandbox',
            '--disable-setuid-sandbox',
            f'--user-agent={device.user_agent}',
            f'--window-size={device.screen_resolution[0]},{device.screen_resolution[1]}'
        ]
    )
    
    context = await browser.new_context(
        viewport={'width': device.screen_resolution[0], 'height': device.screen_resolution[1]},
        user_agent=device.user_agent,
        locale=device.language,
        timezone_id=device.timezone,
        geolocation={'latitude': device.gps_current.lat, 'longitude': device.gps_current.lon},
        permissions=['geolocation']
    )
    
    # Apply stealth plugins
    page = await context.new_page()
    await stealth_async(page)
    
    # Inject additional fingerprint spoofing
    await page.add_init_script(f"""
        // Override navigator properties
        Object.defineProperty(navigator, 'hardwareConcurrency', {{
            get: () => {device.hardware_concurrency}
        }});
        
        Object.defineProperty(navigator, 'deviceMemory', {{
            get: () => {device.device_memory}
        }});
        
        // Spoof canvas fingerprint
        const originalToDataURL = HTMLCanvasElement.prototype.toDataURL;
        HTMLCanvasElement.prototype.toDataURL = function(type) {{
            // Add noise to canvas
            const context = this.getContext('2d');
            const imageData = context.getImageData(0, 0, this.width, this.height);
            for (let i = 0; i < imageData.data.length; i += 4) {{
                imageData.data[i] += Math.floor(Math.random() * 3) - 1;
            }}
            context.putImageData(imageData, 0, 0);
            return originalToDataURL.apply(this, arguments);
        }};
        
        // Spoof WebGL fingerprint
        const getParameter = WebGLRenderingContext.prototype.getParameter;
        WebGLRenderingContext.prototype.getParameter = function(parameter) {{
            if (parameter === 37445) {{
                return '{device.webgl_fingerprint}';  // UNMASKED_VENDOR_WEBGL
            }}
            if (parameter === 37446) {{
                return '{device.webgl_fingerprint}';  // UNMASKED_RENDERER_WEBGL
            }}
            return getParameter.apply(this, arguments);
        }};
    """)
    
    return page
```

#### 2. Mobile Emulation

**Appium Configuration for Realistic Mobile**:
```python
from appium import webdriver

def create_mobile_emulator(device: Device):
    """Create Android/iOS emulator with realistic fingerprint"""
    
    if device.platform == 'Android':
        desired_caps = {
            'platformName': 'Android',
            'platformVersion': device.mobile_os_version,
            'deviceName': device.device_model,
            'app': device.current_platform.app_package,
            'automationName': 'UiAutomator2',
            
            # Location spoofing
            'gpsEnabled': True,
            'location': f'{device.gps_current.lat},{device.gps_current.lon}',
            
            # Device emulation
            'avd': f'persona_{device.id}',  # Custom AVD per persona
            'avdArgs': [
                '-no-snapshot-load',
                '-no-snapshot-save',
            ],
            
            # Network
            'proxy': {
                'proxyType': 'manual',
                'httpProxy': device.proxy_config.address,
                'sslProxy': device.proxy_config.address
            }
        }
    
    elif device.platform == 'iOS':
        desired_caps = {
            'platformName': 'iOS',
            'platformVersion': device.mobile_os_version,
            'deviceName': device.device_model,
            'app': device.current_platform.app_id,
            'automationName': 'XCUITest',
            
            # Location simulation
            'locationServicesEnabled': True,
            'locationServicesAuthorized': True,
            'simulateLocation': {
                'latitude': device.gps_current.lat,
                'longitude': device.gps_current.lon
            }
        }
    
    driver = webdriver.Remote('http://localhost:4723/wd/hub', desired_caps)
    return driver
```

#### 3. Proxy Management

**Residential Proxy Rotation**:
```python
class ProxyManager:
    
    def __init__(self):
        # Option 1: Commercial service (MVP)
        self.commercial_pool = BrightDataProxyPool() if USE_COMMERCIAL else None
        
        # Option 2: Custom proxy network (Phase 2)
        self.custom_proxies = []  # Load from database
    
    async def get_proxy_for_household(self, household: Household) -> ProxyConfig:
        """Get consistent residential proxy for a household"""
        
        # Check if household already has assigned proxy
        if household.residential_proxy:
            # Verify proxy still valid
            if await self.validate_proxy(household.residential_proxy):
                return household.residential_proxy
        
        # Assign new proxy
        new_proxy = await self.acquire_residential_proxy(
            location=household.location,
            isp_preference=household.isp_info
        )
        
        # Save assignment (household keeps same IP)
        household.residential_proxy = new_proxy
        await self.save_household(household)
        
        return new_proxy
    
    async def acquire_residential_proxy(self, location: GeoCoordinates, isp_preference: ISPInfo):
        """Acquire a residential proxy near the specified location"""
        
        if self.commercial_pool:
            # Use commercial service
            return await self.commercial_pool.get_proxy(
                country=location.country,
                city=location.city,
                isp=isp_preference.name
            )
        else:
            # Use custom proxy network
            # TODO: Implement custom proxy server management
            # - Rent VPS in target location
            # - Configure residential-looking IP
            # - Route traffic through local ISP
            pass
    
    async def rotate_if_needed(self, proxy: ProxyConfig, reason: str):
        """Rotate proxy if burned or detected"""
        
        # Log reason for rotation
        await self.log_proxy_rotation(proxy, reason)
        
        # Mark proxy as potentially compromised
        proxy.status = 'cooldown'
        proxy.cooldown_until = datetime.now() + timedelta(hours=24)
        
        # Get replacement
        return await self.acquire_residential_proxy(proxy.location, proxy.isp_info)
```

#### 4. Timing & Rate Limiting

**Human-Like Timing Patterns**:
```python
import random
from datetime import datetime, time

class TimingController:
    
    def get_activity_schedule(self, persona: Persona) -> Dict[str, Any]:
        """Generate realistic daily activity schedule"""
        
        # Base patterns from persona profile
        patterns = persona.activity_patterns
        
        # Typical human behavior: peaks in morning, lunch, evening
        activity_windows = {
            'morning': (time(7, 0), time(9, 0)),
            'lunch': (time(12, 0), time(13, 30)),
            'afternoon': (time(15, 0), time(17, 0)),
            'evening': (time(19, 0), time(23, 0))
        }
        
        # Randomize within windows
        schedule = {}
        for window_name, (start, end) in activity_windows.items():
            if random.random() < patterns.get(f'{window_name}_activity_probability', 0.7):
                # Schedule activity in this window
                activity_time = self.random_time_in_range(start, end)
                schedule[window_name] = activity_time
        
        return schedule
    
    def calculate_delay_between_actions(self, action_type: str) -> float:
        """Calculate realistic delay between actions"""
        
        base_delays = {
            'scroll': (0.5, 3.0),
            'click': (0.3, 2.0),
            'type': (0.05, 0.2),  # Per character
            'page_load': (2.0, 5.0),
            'video_watch': (10.0, 300.0)
        }
        
        min_delay, max_delay = base_delays.get(action_type, (1.0, 3.0))
        
        # Use beta distribution for more realistic variation (humans cluster around mean)
        delay = random.betavariate(2, 5) * (max_delay - min_delay) + min_delay
        
        return delay
    
    async def respect_rate_limits(self, persona: Persona, platform: Platform):
        """Ensure persona doesn't exceed platform rate limits"""
        
        # Get persona's recent activity on this platform
        recent_activity = await self.get_recent_activity(
            persona_id=persona.id,
            platform=platform,
            since=datetime.now() - timedelta(hours=1)
        )
        
        # Platform-specific limits (conservative estimates)
        limits = {
            'TikTok': {'scrolls_per_hour': 500, 'likes_per_hour': 100, 'follows_per_hour': 30},
            'Instagram': {'scrolls_per_hour': 400, 'likes_per_hour': 80, 'follows_per_hour': 20},
            'Facebook': {'scrolls_per_hour': 300, 'likes_per_hour': 60, 'follows_per_hour': 15}
        }
        
        platform_limits = limits.get(platform, {})
        
        # Check if approaching limits
        for action_type, limit in platform_limits.items():
            action_count = sum(1 for a in recent_activity if a.activity_type == action_type)
            
            if action_count >= limit * 0.8:  # 80% of limit
                # Slow down or pause
                cooldown = random.uniform(300, 900)  # 5-15 min break
                await asyncio.sleep(cooldown)
                return
```

#### 5. Behavioral Variation

**Prevent Pattern Detection**:
```python
class BehaviorVariation:
    
    def add_human_imperfection(self, action: Action) -> Action:
        """Add realistic human imperfections to actions"""
        
        # Occasional mistakes
        if random.random() < 0.05:  # 5% chance
            # Missed click, need to retry
            action.retry_count += 1
            action.delay *= 1.5
        
        # Occasional distractions
        if random.random() < 0.1:  # 10% chance
            # User got distracted mid-action
            action.add_pause(random.uniform(5, 30))
        
        # Speed variation based on time of day
        hour = datetime.now().hour
        if 0 <= hour < 6:  # Late night: slower
            action.speed_multiplier *= 0.7
        elif 7 <= hour < 9:  # Morning rush: faster
            action.speed_multiplier *= 1.2
        
        return action
    
    def ensure_persona_consistency(self, persona: Persona, new_activity: Activity):
        """Make sure new activity fits persona's established patterns"""
        
        # Get persona's historical behavior
        history = await self.get_activity_history(persona.id, days=30)
        
        # Check consistency
        avg_session_length = statistics.mean([a.duration for a in history])
        
        if abs(new_activity.duration - avg_session_length) > avg_session_length * 2:
            # This activity is way outside normal range, adjust
            new_activity.duration = random.gauss(avg_session_length, avg_session_length * 0.3)
        
        # Check platform preferences
        platform_usage = Counter(a.platform for a in history)
        if new_activity.platform not in platform_usage:
            # First time using this platform, should be exploratory
            new_activity.engagement_rate *= 0.5
            new_activity.duration *= 0.7
```

#### 6. Detection Response

**What to do when detected**:
```python
class DetectionHandler:
    
    async def handle_detection_event(self, persona: Persona, device: Device, detection_type: str):
        """Respond to platform detection"""
        
        # Log incident
        await self.log_detection(persona, device, detection_type)
        
        if detection_type == 'rate_limit':
            # Temporary, just slow down
            await self.apply_cooldown(persona, platform=device.current_platform, hours=2)
        
        elif detection_type == 'captcha':
            # Need human intervention
            await self.request_human_solve(persona, device)
            # Or use CAPTCHA solving service (risky)
        
        elif detection_type == 'account_locked':
            # Serious, pause persona
            persona.status = 'suspended'
            await self.save_persona(persona)
            await self.alert_admin(f"Persona {persona.name} account locked")
            
            # Rotate device fingerprint and proxy
            new_device = await self.create_fresh_device(persona)
            new_proxy = await self.proxy_manager.rotate_proxy(device.proxy_config, reason='account_locked')
        
        elif detection_type == 'ip_blocked':
            # Rotate proxy immediately
            new_proxy = await self.proxy_manager.rotate_proxy(device.proxy_config, reason='ip_blocked')
            device.proxy_config = new_proxy
            await self.save_device(device)
        
        elif detection_type == 'suspicious_behavior':
            # Platform is watching but hasn't acted yet
            # Reduce activity significantly
            await self.apply_cooldown(persona, platform=device.current_platform, hours=24)
            # Switch to more conservative behavior profile
            persona.activity_patterns['engagement_rate'] *= 0.5
            await self.save_persona(persona)
```

---

> **Note**: Detailed implementation milestones and timeline are maintained in a separate MILESTONES.md document.

---

## Technical Stack Summary

### Backend
- **Primary Language**: Python 3.11+
  - Frameworks: FastAPI (API), Celery (async tasks)
  - Automation: Playwright (web), Appium (mobile)
  - AI: OpenAI API / Anthropic API (narrative generation)

- **Secondary Language**: TypeScript/Node.js
  - Use cases: Real-time features, API gateway

### Frontend
- **Framework**: Angular 17+
- **UI Library**: Angular Material or Tailwind CSS
- **State Management**: NgRx (if complex) or RxJS
- **Visualization**: D3.js, Plotly for analytics

### Infrastructure (GCP)
- **Compute**: Google Kubernetes Engine (GKE)
  - Container orchestration
  - Auto-scaling persona containers
  
- **Storage**:
  - Cloud SQL (PostgreSQL): Structured data (personas, devices, accounts)
  - Firestore: Activity history, behavioral state
  - BigQuery: Analytics, time-series data
  - Cloud Storage: Screenshots, videos, raw HTML
  
- **Messaging**: Cloud Pub/Sub
  - Event-driven architecture
  - Reliable message delivery
  
- **Search**: Elasticsearch (existing)
  - Content search and analysis

### Automation Tools
- **Web**: Playwright with playwright-stealth
- **Mobile**: Appium with Android Emulator / iOS Simulator
- **VNC**: noVNC for remote container viewing

### Proxy Solutions
- **MVP**: Commercial service (Bright Data, Smartproxy, etc.)
- **Future**: Custom residential proxy network
  - VPS in target countries
  - Residential IP leasing

### Monitoring & Observability
- **Metrics**: Prometheus + Grafana (existing)
- **Logging**: Cloud Logging (Stackdriver)
- **Alerting**: Cloud Monitoring
- **Tracing**: OpenTelemetry (optional)

### Development Tools
- **Containerization**: Docker, Docker Compose (local dev)
- **CI/CD**: Cloud Build, GitHub Actions
- **IaC**: Terraform (infrastructure as code)
- **Version Control**: Git (GitHub/GitLab)

---

## Integration with Existing Infrastructure

### Current System (To Be Phased Out)

Based on discussion, existing system includes:
- **Storage**: GCP buckets, Elasticsearch, SQL databases
- **Admin**: Django admin (slow, cumbersome)
- **Monitoring**: Grafana dashboards
- **Proxies**: Basic rotation (being improved by junior team member)
- **Debugging**: VNC via Selenium

### Integration Points

**Phase 1 (MVP): Minimal Integration**
- Persona writes captured ads directly to existing GCS buckets (same structure)
- Publishes ad capture events to existing Pub/Sub topics
- Reuses existing proxy infrastructure (if stable)
- Runs independently in separate GKE namespace

**Phase 2: Deeper Integration**
- Persona reads targeting rules from existing SQL database
- Shares Elasticsearch cluster for content indexing
- Feeds data into existing Grafana dashboards
- API endpoints for existing systems to query persona status

**Phase 3: Full Integration**
- Existing admin can create/manage personas via shared API
- Unified authentication/authorization
- Consolidated monitoring and alerting
- Data pipeline integration (Persona → ETL → Analytics)

### Migration Strategy

1. **Parallel Operation**: Run Persona alongside existing system
2. **Gradual Transition**: Shift workloads from old to new incrementally
3. **Data Validation**: Ensure Persona captures same/better data quality
4. **Feature Parity**: Match existing system capabilities before deprecation
5. **Deprecation**: Phase out old system once Persona proven at scale

---

## Development Workflow

### Local Development

**Prerequisites**:
- Docker Desktop
- Python 3.11+, Node.js 18+
- kubectl, gcloud CLI

**Setup**:
```bash
# Clone repo
git clone <repo-url>
cd persona

# Start local infrastructure (PostgreSQL, Firestore emulator, Pub/Sub emulator)
docker-compose -f docker-compose.dev.yml up -d

# Install backend dependencies
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Install frontend dependencies
cd ../frontend
npm install

# Run backend
cd ../backend
python main.py

# Run frontend (separate terminal)
cd ../frontend
ng serve

# Run a test persona locally
python scripts/run_test_persona.py --persona-id test-001
```

**Testing Strategy**:
- **Unit Tests**: Atomic actions, behavioral primitives (pytest)
- **Integration Tests**: Full persona lifecycle (Docker Compose)
- **E2E Tests**: Real platform interaction (staging environment)
- **Manual Testing**: VNC into containers, observe behavior

### Deployment

**Development Environment**:
- GKE cluster: `persona-dev`
- Auto-deploys from `develop` branch
- Uses test/sandbox accounts on platforms

**Staging Environment**:
- GKE cluster: `persona-staging`
- Deploys from `staging` branch after QA approval
- Uses dedicated staging personas (isolated from production)

**Production Environment**:
- GKE cluster: `persona-prod`
- Deploys from `main` branch after stakeholder approval
- 20+ personas running 24/7
- Careful rollout (canary deployments, gradual rollouts)

---

## Risk Mitigation & Compliance

### Legal & Ethical Considerations

**Gray Area Acknowledgment**:
- Most platforms prohibit automated access/scraping in ToS
- Company position: Creating realistic simulations for research, not manipulation
- Plausible deniability: Personas behave like real users

**Risk Mitigation**:
1. **Screen Recording Fallback**: For high-risk platforms, record screens instead of direct scraping
2. **No Data Resale**: Don't sell raw data, only insights/analytics
3. **Minimal Footprint**: Don't overwhelm platforms, stay under radar
4. **No Manipulation**: Don't artificially inflate metrics, spam, or engage in deceptive practices

### Technical Risks

**Detection & Account Loss**:
- **Risk**: Platforms detect automation, ban accounts
- **Mitigation**: Sophisticated anti-detection, graceful degradation, account rotation

**Data Loss**:
- **Risk**: Storage failures, accidental deletion
- **Mitigation**: Event sourcing (immutable events), backups, replication

**Cost Overruns**:
- **Risk**: GCP costs spiral with scale
- **Mitigation**: Budget alerts, cost optimization, efficient storage strategies

**Performance Degradation**:
- **Risk**: System slows down as scale increases
- **Mitigation**: Horizontal scaling, database optimization, caching

### Operational Risks

**System Complexity**:
- **Risk**: Too many moving parts, hard to debug
- **Mitigation**: Comprehensive logging, monitoring, documentation

**Key Person Risk**:
- **Risk**: Main developer (you) leaves, system unmaintainable
- **Mitigation**: Extensive documentation (this file!), code reviews, knowledge sharing

**Platform Changes**:
- **Risk**: Social media platforms change UI/API, breaking automation
- **Mitigation**: Abstraction layers, quick iteration, monitoring for breakages

---

## Success Metrics & KPIs

### System Health
- **Uptime**: 99%+ for persona containers
- **Detection Rate**: <3% of personas flagged per month
- **Error Rate**: <1% of activities fail
- **Recovery Time**: <5 minutes to restart failed persona

### Data Capture
- **Ads Captured**: >100 per persona per day
- **Ad Quality**: >95% of ads fully captured (screenshot + metadata)
- **Content Captured**: Selective, rule-based (TBD in Phase 2)
- **Storage Efficiency**: <$X per GB stored

### Behavioral Realism
- **Activity Consistency**: Persona behavior matches profile 95%+ of time
- **Cross-Platform Coherence**: Interest correlation >0.8 across platforms
- **Human Review**: AI narratives pass as realistic 90%+ of time

### Business Value
- **Client Insights**: X actionable insights per month
- **Competitive Intelligence**: Coverage of Y% of competitor ads
- **Cost per Insight**: $Z per actionable report
- **Stakeholder Satisfaction**: Dashboard demo success rate 90%+

---

## Future Enhancements (Wishlist)

### Advanced Features
- **Persona Marketplace**: Pre-built persona templates for common demographics
- **Collaborative Filtering**: Recommend content to personas based on similar users
- **Trend Prediction**: Identify emerging trends before they go mainstream
- **Adversarial Testing**: Red-team the system to find detection vulnerabilities

### Research Applications
- **Ad Targeting Research**: Reverse-engineer platform algorithms
- **Filter Bubble Analysis**: How do personas in echo chambers behave?
- **Misinformation Spread**: Track how fake news propagates (ethical concerns!)

### Platform Expansion
- **Other Social Media**: Twitter/X, Threads, Snapchat, Pinterest, Reddit
- **E-commerce**: Amazon, eBay (product recommendation testing)
- **Streaming**: Netflix, Spotify (recommendation algorithm analysis)
- **OTT Devices**: Smart TVs, Roku, Apple TV (Phase 3+)

---

## Appendix: Key Definitions

**Persona**: Simulated digital identity with demographics, interests, and behavioral patterns

**Household**: Group of personas sharing physical location and some devices (realistic family simulation)

**Device**: Virtual or physical device with unique fingerprint (mobile, desktop, tablet, OTT)

**Activity**: Single action or behavior performed by a persona (browse, search, watch, etc.)

**Narrative**: AI-generated plan describing what a persona will do over a time period

**Behavioral Primitive**: Mid-level reusable behavior composed of atomic actions

**Atomic Action**: Low-level browser/mobile automation command (click, scroll, type, etc.)

**Ad Capture**: Screenshot + metadata extraction of an advertisement

**Detection**: Platform identifying persona as automated and taking action (rate limit, CAPTCHA, ban)

**Event Sourcing**: Architectural pattern where all state changes are stored as immutable events

**Anti-Detection**: Techniques to make automated personas indistinguishable from real users

---

## Contact & Collaboration

**Primary Developer**: [Your Name/Team]
**Project Status**: Planning → Development (MVP)
**Repository**: [GitHub/GitLab URL]
**Documentation**: [Confluence/Notion/Wiki URL]
**Slack Channel**: #persona-project

---

## Changelog

**v1.0 (2025-11-03)**: Initial comprehensive project specification
- Complete architecture design
- Three-layer behavior system
- Implementation roadmap (MVP → Phase 3)
- Technical stack decisions
- Anti-detection strategy
- Integration plan with existing infrastructure

**Future Updates**:
- Refine based on MVP learnings
- Add code examples from actual implementation
- Document platform-specific gotchas
- Performance optimization notes

---

## TODO / Open Questions

**High Priority**:
- [ ] Finalize commercial proxy service (team junior investigating)
- [ ] Decide on AI model for narrative generation (GPT-4 vs Claude vs fine-tuned)
- [ ] Establish baseline detection rates before optimization
- [ ] Design Elasticsearch schema for ad metadata
- [ ] Define exact GCS bucket structure for screenshots

**Medium Priority**:
- [ ] Household relationship modeling (how complex to make it?)
- [ ] Content capture rules (what criteria for selective capture?)
- [ ] GPS transition realism (Phase 2+, deprioritized for now but leave architecture open)
- [ ] Physical device farm ROI analysis (when does it make sense?)

**Low Priority / Future**:
- [ ] Reinforcement learning for behavior optimization
- [ ] Persona "personality" evolution over time
- [ ] Cross-persona interactions (family dynamics simulation)
- [ ] OTT device integration (smart TVs, streaming sticks)

---

**END OF DOCUMENT**

*This document serves as the comprehensive guide for building the Persona system. It should be updated as the project evolves, decisions are made, and learnings are discovered. Treat it as a living document.*

*Next step: Share with Claude Code to begin implementation of MVP Phase 1.*
