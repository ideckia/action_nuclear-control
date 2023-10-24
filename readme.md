# Action for [ideckia](https://ideckia.github.io/): nuclear-control

## Description

Action to control [Nuclear](https://nuclear.js.org) music player. First of all you have to enable API in the Nuclear player itself.

`Settings->HTTP API->Check 'Enable the api'`

The items icons are customizable. Just put the images in the `[ideckia_dir]/actions/nuclear-control/img` directory. These are the images that this action looks for:

* nuclear_icon.png
* previous.png
* next.png
* play.png
* pause.png

## Properties

| Name | Type | Description | Shared | Default | Possible values |
| ----- |----- | ----- | ----- | ----- | ----- |
| port | Int | Port used by the API | false | 3100 | null |

## On single click

Opens a basic control-panel with the album cover, play-pause, next, previous buttons

## On long press

nothing

## Example in layout file

```json
{
    "text": "nuclear-now-playing-item action example",
    "actions": [
        {
            "name": "nuclear-now-playing-item",
            "props": {
                "port": 3100
            }
        }
    ]
}
```
