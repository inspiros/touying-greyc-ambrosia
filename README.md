touying-greyc-ambrosia
------

`touying-greyc-ambrosia` is an _unofficial_ [Touying](https://github.com/touying-typ/touying) theme for creating presentation slides in [Typst](https://github.com/typst/typst).
It is intended for members of the [GREYC](https://www.greyc.fr/en/home/) lab, and is designed (by default) to mimic the official LaTeX & PPT templates provided in https://www.greyc.fr/intranet.
However, the theme comes with a lot of modifications and a range of different variants.
You are free to use or modify it for your own academic presentations, regardless of your affiliation.

## Features

_to be added_

## Usage

For now, you can only download it manually:

```console
git clone https://github.com/inspiros/touying-greyc-ambrosia
```

In the near future, this theme will be available in the Typst universe.

```typ
#import "@preview/touying-greyc-ambrosia:0.1.0": *

#show: greyc-theme.with(
  // legacy | stargazer | dewdrop | cambridge | darmstadt
  flavor: "legacy",
  aspect-ratio: "16-9",
  config-info(
    title: [Title],
    subtitle: [Subtitle],
    author: [Author],
    date: datetime.today(),
    institution: [Institution],
  ),
)

#title-slide()

= Section Title

== Slide

#lorem(30)

#ending-slide()[
  Thanks for your attention!
]
```

### Examples

For more sophisticated use cases, please check [`examples/demo.typ`](examples/basic.typ) and [`examples/demo.pdf`](examples/basic.pdf).

## Fun Fact

*Ambrosia*: The food of the Greek gods, often described as having every flavor imaginable.

## License

MIT licensed, see [LICENSE](LICENSE).
