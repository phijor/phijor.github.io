# Constructive Final Semantics of Finite Bags

[![GitHub: phijor/agda-cubical-multiset](https://img.shields.io/badge/GitHub-phijor%2Fagda--cubical--agda-2EBC4F)][agda-cubical-multiset]
[![Agda: README.agda](https://img.shields.io/badge/Agda-README.agda-orange)][README]
[![DOI: 10.4230/LIPIcs.ITP.2023.20](https://img.shields.io/badge/DOI-10.4230%2FLIPIcs.ITP.2023.20-085DA6.svg?logo=DOI)][doi]

## Abstract

Finitely-branching and unlabelled dynamical systems are typically modelled as coalgebras for the finite powerset functor.
If states are reachable in multiple ways, coalgebras for the finite bag functor provide a more faithful representation.
The final coalgebra of this functor is employed as a denotational domain for the evaluation of such systems.
Elements of the final coalgebra are non-wellfounded trees with finite unordered branching,
representing the evolution of systems starting from a given initial state.

This paper is dedicated to the construction of the final coalgebra of the finite bag functor in homotopy type theory (HoTT).
We first compare various equivalent definitions of finite bags employing higher inductive types, both as sets and as groupoids (in the sense of HoTT).
We then analyze a few well-known, classical set-theoretic constructions of final coalgebras in our constructive setting.
We show that, in the case of set-based definitions of finite bags,
some constructions are intrinsically classical, in the sense that they are equivalent to some weak form of excluded middle.
Nevertheless, a type satisfying the universal property of the final coalgebra can be constructed in HoTT employing the groupoid-based definition of finite bags.
We conclude by discussing generalizations of our constructions to the wider class of analytic functors.

The full paper is avaiable at [10.4230/LIPIcs.ITP.2023.20][doi]
as part of [LIPIcs, Volume 268, ITP 2023](https://www.dagstuhl.de/dagpub/978-3-95977-284-6).

## Formalization

The paper comes with an Agda formalization, based on the [Agda Cubical](https://github.com/agda/cubical) library,
available [here][README].

[agda-cubical-multiset]: https://github.com/phijor/agda-cubical-multiset
[README]: https://phijor.me/agda-cubical-multiset/README.html
[doi]: https://doi.org/10.4230/LIPIcs.ITP.2023.20
