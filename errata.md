# Errata

This document lists any errors and/or corrections to the printed material of the book. This does not indicate errors with the code in this repository, which is
tested and updated separately.

## Chapter 1

p.5 - [GRAMMAR] : "There never" -> "There's never"

## Chapter 2

p.49 - [CODE] : $MarginContainer/TimeLabel.txt -> $MarginContainer/TimeLabel.text

## Chapter 3

p.76 - [MISSING] : Select the Enemy node, click on the "Node" tab, and add the enemy to the "enemies" group

p.76 - [CODE]: Missing indentation.
        ```
        if area.has_method('pickup'):
            area.pickup()
            if area.type == 'key_red':
                emit_signal('grabbed_key')
            if area.type == 'star':
                emit_signal('win')
        ```