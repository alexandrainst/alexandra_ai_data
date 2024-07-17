<div align='center'>
 <img src="https://raw.githubusercontent.com/alexandrainst/AlexandraAI/main/gfx/alexandra-ai-logo-dark.svg">
</div>

### Easy Access to Danish Data Sources

______________________________________________________________________
[![PyPI Status](https://badge.fury.io/py/alexandra_ai_data.svg)](https://pypi.org/project/alexandra_ai_data/)
[![Documentation](https://img.shields.io/badge/docs-passing-green)](https://alexandrainst.github.io/alexandra_ai_data/alexandra_ai_data.html)
[![License](https://img.shields.io/github/license/alexandrainst/alexandra_ai_data)](https://github.com/alexandrainst/alexandra_ai_data/blob/main/LICENSE)
[![LastCommit](https://img.shields.io/github/last-commit/alexandrainst/alexandra_ai_data)](https://github.com/alexandrainst/alexandra_ai_data/commits/main)
[![Code Coverage](https://img.shields.io/badge/Coverage-100%25-brightgreen.svg)](https://github.com/alexandrainst/alexandra_ai_data/tree/main/tests)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.0-4baaaa.svg)](https://github.com/alexandrainst/alexandra_ai_data/blob/main/CODE_OF_CONDUCT.md)

## Installation

To install the package simply write the following command in your favorite terminal:

```
pip install alexandra-ai-data
```

### Domsdatabasen
The processing part of the Domsdatabasen API depends on [poppler](https://poppler.freedesktop.org/). To install it on macOS, run the following command:

```
brew install poppler
```

This is only necessary if you use the API to get cases that are not in [the cached dataset](https://huggingface.co/datasets/alexandrainst/domsdatabasen).

## Quickstart

### Domsdatabasen usage example
```python
from alexandra_ai_data.domsdatabasen import Domsdatabasen

domsdatabasen = Domsdatabasen()

case = domsdatabasen.get_case(case_id="100")

print(case)
```


## Contributors

If you feel like this package is missing a crucial feature, if you encounter a bug or
if you just want to correct a typo in this readme file, then we urge you to join the
community! Have a look at the [CONTRIBUTING.md](./CONTRIBUTING.md) file, where you can
check out all the ways you can contribute to this package. :sparkles:

- _Your name here?_ :tada:

## Maintainers

The following are the core maintainers of the `alexandra_ai_data` package:

- [@saattrupdan](https://github.com/saattrupdan) (Dan Saattrup Nielsen; saattrupdan@alexandra.dk)
