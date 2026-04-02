# 🔲 Jumping Square

Today I want to share how I built a highly simplified Geometry Dash clone using Flutter. The goal of the game is simple: survive as long as possible without crashing into anything.

## Technologies

* **Dart + Flutter** (Core framework)
* **Riverpod** (State management)
* **Canvas & CustomPainter** (All rendering happens here)
* **Shared Preferences** (Local high score storage)

## The Process

**Design & Initial Thoughts**
I started by creating the initial design in Figma. Initially, I wanted to create multiple types of obstacles... but I got tired after building the first one, so I stuck with it. One is enough!

**Physics & Collisions**
The main question I faced was: How does the square know it's on the ground or has jumped onto a block?
Horizontally, the player always stands still, while the world simply moves towards them. All calculations happen exclusively vertically.

Every frame, the game does two checks:
1. By default, the floor is at coordinate zero. But if the loop detects that an obstacle is passing directly under the cube, the game temporarily makes the top edge of that obstacle our new ground.
2. As soon as the player's calculated height drops below the current ground coordinate, the square has landed.

At this exact moment, I reset the falling speed to zero, clamp the cube to the surface, and rotate to the nearest 90-degree angle so it stands flat on its face, rather than getting stuck on an edge.

**Architecture & Structure**
I divided the project into logical layers:
* **Data:** Encapsulated the work with local storage.
* **Domain:** Extracted game statuses and obstacle types, then created models for the player, obstacles, and the world.
* **Presentation:** A unified game state that ties everything together for the UI to listen to.

**The Engine (GameController)**
It is a class to manage animations, physics, and collisions.

Key fields in the controller:
* `gravity`: How fast the player falls.
* `jumpVelocity`: The player's jumping force.
* `worldSpeed`: The speed at which obstacles move toward the player.
* `blockSize`: The base size from which everything else is calculated.

For the game loop, a special `Ticker` object fires a callback for every frame (usually 60 times per second).

The core methods:
* `_updatePhysics(...)`: Calculates the player's new height and rotation. The player's rotation changes continuously until touching the ground. Upon landing, it snaps to the nearest right angle to keep the player straight.
* `_moveWorld(...)`: Moves the game field and generates obstacles.
* `_checkCollisions(...)`: Registers hits with obstacles.

**The Math**
I had to dig into high school physics and tie velocity and gravity calculations to Delta Time (dt):

* **New Velocity:** v = v0 + g * dt
* **New Position (Y Height):** y = y0 + v * dt
* **Max Jump Height:** h = v^2 / (2 * g)
*(Where h is max height in pixels, v is initial jumpVelocity, and g is gravity).*

Finally, I created a `CustomPainter` to draw every frame and assembled the screen. 

## Running the Project (Android)

To run this project locally, ensure you have an emulator or physical device connected:

1. Clone the repository
2. Install dependencies: `flutter pub get`
3. Run the app: `flutter run`

## Preview

![App Demo](https://github.com/ingvar-m/jumping_square/blob/main/jumping_square.gif)
