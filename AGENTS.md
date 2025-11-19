# Cleangoon - Development History

## Project Overview
Cleangoon is a 2D underwater cleanup game built with Godot 4.2. Players control an underwater cleaning vehicle to collect trash while avoiding hostile fish. The game features an upgrade system, various trash types, and dynamic AI behavior.

## Major Development Milestones

### Pre-Release State (June 26, 2024)
**Commit:** `7482175` - Pre-release preparation with major polish and content additions

#### Audio & Visual Enhancements
- Added comprehensive sound effects library:
  - UI sounds (denied, use item, buy/sell)
  - Gameplay sounds (blade swing, pickups, impacts)
  - Three different soundtrack loops
  - Engine sounds for player vehicle
- Added parallax background layers (Summer2, Summer3, far.png)
- Introduced animated trash effects (SFX304 series animations)
- Added leaf particles and visual effects

#### Level Design
- Created `level_1.tscn` and `level_2.tscn` with full tileset integration
- Added level manager system for progression
- Introduced tutorial level with shader effects
- Added houses and environmental decorations

#### Game Systems
- Implemented comprehensive level management system
- Added game over screen and loading screen
- Created restart and quit functionality
- Enhanced tutorial system with UI guidance
- Added interact button prompts (space/shift icons with gamepad support)

#### UI/UX Improvements
- Added upgrade card UI for shop system (boost, ginsu-2000, lantern, strong-arm)
- Implemented special storage UI indicator
- Enhanced health bar and stamina pip displays
- Added cannot buy/interact feedback popups
- Improved animation player for purchase confirmations

#### Export Configuration
- Added `export_presets.cfg` for game distribution
- Created game icon (limpa-i-989.ico/png)
- Prepared build for Windows and Linux platforms

---

### Upgrade System Features (June 14, 2024)
**Commit:** `eaf9080` - Major gameplay features: lantern, grass cutter, boost, and chemical trash

#### New Upgrades
1. **Lantern/Flashlight**
   - Illuminates dark underwater areas
   - Integrated with player entity as `PointLight2D` and `LightOccluder2D`
   - Toggle visibility based on purchase status

2. **Grass Cutter (Ginsu-2000)**
   - Allows cutting through thick underwater grass
   - Grass has two states: closed (blocking) and open (cut)
   - Collision shapes adjust based on grass state
   - Visual feedback with different textures (thick-grass.png, thick-grass-cutted.png)

3. **Boost System**
   - Triple boost charges with visual pip indicators
   - Recovery timer system for boost regeneration
   - Enhanced player physics during boost state
   - UI displays remaining boost charges

4. **Chemical Trash Type**
   - New hazardous waste category with animated uranium sprites
   - Requires special handling and storage
   - Added to trash data system with specific interaction areas

#### Technical Improvements
- Enhanced `PlayerPhysics` with boost acceleration
- Improved `TrashCollector` to handle chemical waste separately
- Added grass entity with interactive collision detection
- Expanded `PlayerData` resource with upgrade tracking
- Created "cannot pick trash" UI popup for blocked interactions

---

### Chemical Trash & Shop Integration (June 12, 2024)
**Commits:** `fbf948f`, `16d1de9`

#### Chemical Trash System
- Introduced uranium as first chemical waste type
- Added raw and processed uranium sprites
- Integrated chemical trash into collection mechanics
- Specialized trash data resources for hazardous materials

#### Strong Arm Purchase System
- Implemented strong arm upgrade purchase functionality
- Allows carrying heavy objects without dropping them
- Added UI feedback for purchase confirmation
- Integrated with player's upgrade tracking system

---

### Damage System (June 5, 2024)
**Commits:** `0020a30`, `0edd8e8`

#### Health & Combat
- Implemented player damage system with fish attacks
- Added health manager with health bar UI
- Created hurtbox/hitbox collision system
- Fish can now damage player on contact or bite
- Player has recovery timer after taking damage

#### Upgrade Shop UI
- Created card-based upgrade shop interface
- Visual representation of available upgrades
- Purchase confirmation dialogs
- Cannot buy popup when insufficient funds
- Money display integration

---

### Core AI Behavior (May 27, 2024)
**Commits:** `485cf54`, `ac949e9`

#### Fish AI Implementation
- **Wandering Behavior:** Idle patrol patterns with obstacle avoidance
- **Player Detection:** Sight-based detection using polygon collision shapes
- **Chase Behavior:** Pursuit of player when detected
- **Return to Spawn:** Fish return to origin point after losing player
- **Search Mode:** Investigates last known player location
- **Wall Detection:** Enhanced raycasts for navigation (left, right, top, down, return detection)

#### Technical Features
- Separate sight shapes for left/right facing (mudfish_sight_left/right, salmon_sight_left/right)
- Dynamic direction flipping with collision shape swapping
- Spawn point memory and pathfinding
- Stuck timer to reset fish if trapped
- Surface detection to prevent fish from leaving water

---

### Trash Collection System (May 22-23, 2024)
**Commits:** `52f630a`, `c262fc5`

#### Collection Mechanics
- Pick up and drop trash with action button
- Trash follows player when carried (offset positioning based on facing direction)
- Deliver trash to collection point for money
- Different trash types: common, heavy, chemical
- Interaction area detection system
- Ground/lifted texture states for trash

#### Trash Collector
- Delivery point entity for trash disposal
- Money reward system based on trash type
- UI counter for collected trash
- Interaction prompts when near delivery point

---

### Core Entity Development (May 20-22, 2024)

#### Fish Entity (`56f6a05`)
- Created base fish class with RigidBody2D physics
- FishData resource system for configuration
- Mouth collision shape for attacks
- Sight detection areas
- Animation helper integration
- Support for multiple fish species (Mudfish, Salmon)

#### Trash Entity (`c4a7a69`)
- TrashData resource-based configuration
- Dynamic sprite and collision shape loading
- Interaction area system
- Physics-based movement
- Ground detection with raycasts

#### Player Entity (`5341824`, `6922432`)
- RigidBody2D-based physics movement
- PlayerController for input handling
- PlayerPhysics resource for movement parameters
- Animation system with sprite flipping
- Strong arm visual when upgrade purchased
- Trash grabbing and carrying mechanics
- Engine sounds tied to vertical movement
- GPU particles for visual effects

---

### Initial Setup (May 18, 2024)
**Commit:** `515cb17`

- Project initialization with Godot 4.2
- Basic player movement implementation
- Setup of core game structure
- Resource folder organization
- Asset pipeline configuration

---

## Technical Architecture

### Resource-Based Design
The project uses Godot's resource system extensively for configuration:
- `PlayerData.gd/tres` - Player stats and upgrade state
- `PlayerPhysics.gd/tres` - Movement and physics parameters
- `PlayerController.gd/tres` - Input mapping
- `TrashData.gd/tres` - Trash type configurations
- `FishData.gd/tres` - Fish species data
- `FishBehaviour.gd/tres` - AI behavior parameters

### Signal-Based Communication
- Player signals: grabbed_trash, released_trash, delivered_trash, opened_shop, received_damage
- Trash signals: player_entered_interaction_range, player_left_interaction_range, player_dropped_trash
- Fish signals: point_reached, turn (via FishBehaviour)

### Autoload System
- `Soundtrack.tscn` - Global audio management
- `Game` node - Central game state management with PlayerData

---

## Asset Integration

### Audio
- Retro-style sound effects for actions
- Looping background music tracks
- Engine sounds with RPM variation
- UI feedback sounds

### Sprites
- Player sprites with facing directions and strong arm variant
- Multiple trash types (common, heavy, chemical) with ground/lifted states
- Fish sprites (Mudfish, Salmon) with size variations
- Environmental tiles and parallax backgrounds
- UI elements (cards, icons, health bars, buttons)

### Fonts
- PublicPixel font (.otf and .ttf) for pixel-art aesthetic

---

## Key Features Summary

✅ **Player Mechanics**
- Physics-based underwater movement with gravity
- Boost system with multiple charges
- Trash pickup, carry, and delivery
- Strong arm upgrade for heavy objects
- Flashlight for dark areas
- Grass cutting ability

✅ **Enemy AI**
- Wandering, chasing, searching, and returning behaviors
- Line-of-sight detection
- Obstacle avoidance
- Surface boundary detection

✅ **Trash System**
- Three trash categories: Common, Heavy, Chemical
- Different textures for ground/lifted states
- Interaction areas and physics
- Delivery and reward mechanics

✅ **Upgrade Shop**
- Card-based UI for purchases
- Four upgrades: Boost, Strong Arm, Ginsu-2000, Lantern
- Money system tied to trash collection
- Visual feedback for purchases and errors

✅ **Level Design**
- Tutorial level with guidance
- Multiple gameplay levels
- Level manager for progression
- Tileset-based environments
- Parallax backgrounds

✅ **Polish**
- Sound effects and music
- Particle effects
- Animated sprites
- UI feedback systems
- Game over and restart functionality

---

## Development Approach
The project followed an iterative, feature-based development approach:
1. Core entities (Player, Trash, Fish)
2. Interaction systems (Collection, Delivery)
3. AI behaviors (Detection, Chase, Return)
4. Upgrade systems (Shop, Purchases)
5. Advanced features (Boost, Lantern, Grass cutting)
6. Level design and progression
7. Polish (Audio, VFX, UI/UX)

All major features were developed in separate branches and merged via pull requests, maintaining a clean main branch for stable builds.
