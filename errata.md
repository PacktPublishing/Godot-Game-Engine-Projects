# Errata

This document lists any errors and/or corrections to the printed material of the book. This does not indicate errors with the code in this repository, which is
tested and updated separately.

## Chapter 1

p.5 - [GRAMMAR] : "There never" -> "There's never"

## Chapter 2

p.40 - [CODE] : Missing var. At p.44 "c.screensize" can't be ok without this.

    extends Area2D

    var screensize = Vector2() ## this line is missing

    func pickup():
        queue_free()

p.49 - [CODE] : `$MarginContainer/TimeLabel.txt` -> `$MarginContainer/TimeLabel.text`

## Chapter 3

p.76 - [MISSING] : Select the Enemy node, click on the "Node" tab, and add the enemy to the "enemies" group

p.76 - [CODE] : Missing indentation.

    if area.has_method('pickup'):
        area.pickup()
        if area.type == 'key_red':
            emit_signal('grabbed_key')
        if area.type == 'star':
            emit_signal('win')

## Chapter 4

p.119 - [CODE] : missing declaration: var `screensize`

Now, add this to Main.gd:

   export (PackedScene) var Rock

   var screensize = Vector2() ## this line is missing

   func _ready():
       randomize()
       screensize = get_viewport().get_visible_rect().size
       $Player.screensize = screensize
       for i in range(3):
           spawn_rock(3)

## Chapter 5

p.166 - [CODE] : missing newline character:

    if state == JUMP and velocity.y > 0:
        new_anim = 'jump_down'Testing the moves