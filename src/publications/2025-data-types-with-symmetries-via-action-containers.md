# Data Types with Symmetries via Action Containers

[![GitHub: phijor/cubical-containers](https://img.shields.io/badge/GitHub-phijor%2Fcubical--containers-2EBC4F)][cubical-containers]
[![Agda: README.agda](https://img.shields.io/badge/Agda-README.agda-orange)][readme]
[![PDF: Draft](https://img.shields.io/badge/PDF-Draft-red)][draft-pdf]

## Abstract

We study two kinds of containers for data types with symmetries in homotopy type theory,
and clarify their relationship by introducing the intermediate notion of action containers.
Quotient containers are set-valued containers with groups of permissible permutations of positions, interpreted as analytic functors on the category of sets.
Symmetric containers encode symmetries in a groupoid of shapes, and are interpreted accordingly as polynomial functors on the 2-category of groupoids.

Action containers are endowed with groups that act on their positions, with morphisms preserving the actions.
We show that, as a category, action containers are equivalent to the free coproduct completion of a category of group actions.
We derive that they model non-inductive single-variable strictly positive types in the sense of [Abbott et al.][categories-of-containers]:
The category of action containers is closed under arbitrary (co)products and exponentiation with constants.
We equip this category with the structure of a locally groupoidal 2-category, and prove that this corresponds to the full 2-subcategory of symmetric containers whose shapes have pointed connected components.
This follows from the embedding of a 2-category of groups into the 2-category of groupoids, extending the delooping construction.

## Resources

* a [draft][draft-pdf] of the paper
* a formalization of the results, interactively explorable [online][readme] ([source code][cubical-containers])
* [slides][slides-pdf] for a talk on the topic, held in the [CS Theory Seminar (TSEM)][TSEM] at Tallinn University of Technology

[cubical-containers]: https://github.com/phijor/cubical-containers
[readme]: https://phijor.me/cubical-containers/README.html
[draft-pdf]: ./2025-data-types-with-symmetries-via-action-containers.pdf
[categories-of-containers]: https://doi.org/10.1016/j.tcs.2005.06.002
[TSEM]: https://niccoloveltri.github.io/tsem24/joram.html
[slides-pdf]: ./2025-TSEM-action-containers.pdf
