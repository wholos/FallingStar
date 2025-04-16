import terminal, random, os, strformat, posix

const
  StarChar = '*'
  FrameDelay = 100
  MaxStars = 100

type
  Star = object
    x, y: int

var
  width, height: int
  stars: seq[Star]
  running = true

proc showHelp() =
  echo """
  Falling Stars

  Use:
    ./fallingstar              Start program.
    ./fallingstar --help       Help message.

    Ctrl+C              Exit.
  """
  quit(0)

proc sigintHandler(signal: cint) {.noconv.} =
  running = false
  showCursor()
  eraseScreen()
  quit(0)

proc initStars() =
  stars.setLen(0)
  for _ in 0..<MaxStars:
    stars.add(Star(x: rand(0..<width), y: rand(0..<height)))

proc updateStars() =
  for i in 0..<stars.len:
    stars[i].y += 1
    if stars[i].y >= height:
      stars[i].y = 0
      stars[i].x = rand(0..<width)

proc drawStars() =
  eraseScreen()
  for star in stars:
    setCursorPos(star.x, star.y)
    stdout.write(StarChar)
  stdout.flushFile()

proc main() =
  if "--help" in commandLineParams():
    showHelp()

  var sa: SigAction
  sa.sa_handler = sigintHandler
  sa.sa_flags = 0
  discard sigemptyset(sa.sa_mask)
  discard sigaction(SIGINT, sa)

  randomize()
  hideCursor()
  width = terminalWidth()
  height = terminalHeight()
  initStars()

  while running:
    updateStars()
    drawStars()
    sleep(FrameDelay)

  showCursor()
  eraseScreen()

when isMainModule:
  main()
