# Derivatives of Containers in Univalent Foundations

[![Codeberg: phijor/derivatives](https://img.shields.io/badge/codeberg-phijor%2Fderivatives-2185D0?logo=codeberg)][codeberg]
[![Agda Code](https://img.shields.io/badge/Agda-Overview-orange)][agda]
[![arXiv: 2512.17484](https://img.shields.io/badge/arXiv-2512.17484-B31B1B.svg?logo=arXiv)][arxiv]

## Abstract

Containers conveniently represent a wide class of inductive data types.
Their derivatives compute representations of types of one-hole contexts,
useful for implementing tree-traversal algorithms.
In the category of containers and cartesian morphisms,
derivatives of discrete containers (whose positions have decidable equality) satisfy a universal property.

Working in Univalent Foundations, we extend the derivative operation to _untruncated_ containers (whose shapes and positions are arbitrary types).
We prove that this derivative, defined in terms of a set of _isolated positions_,
satisfies an appropriate universal property in the wild category of untruncated containers and cartesian morphisms,
as well as basic laws with respect to constants, sums and products.
A chain rule exists, but is in general non-invertible.
In fact, a globally invertible chain rule is inconsistent in the presence of non-set types,
and equivalent to a classical principle when restricted to set-truncated containers.
We derive a rule for derivatives of smallest fixed points from the chain rule,
and characterize its invertibility.
All of our results are formalized in Cubical Agda.

## Agda formalization

We formalize our results as an Agda library,
depending on Agda (version 2.8.0) and the cubical library (v0.9).
An online version of the library can be browsed [here][agda].

The source code and related files can are hosted on Codeberg at [phijor/derivatives][codeberg].

[agda]: https://phijor.me/derivatives/
[arxiv]: https://arxiv.org/abs/2512.17484
[codeberg]: https://codeberg.org/phijor/derivatives
