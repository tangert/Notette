#  [Folder] Components

This folder contains all components (in UIKit terms: subviews) of the main interface. This includes the camera view, the keyboard, the key selector, and the color palette. Each of these are then composed in the main VC and VM programtically, and as declaritively as possible without messing with too many conventions from UIKit.

Each component may contain subviews that contribute to its own component.

For example, the Palette component contains subviews for its collection view cells. Everything is self composed and constructed hierarchically and declaritively.
