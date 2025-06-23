---
title: mybatis/generator
date: 2016-11-13
external_link: 'https://github.com/mybatis/generator/pull/173'
tags:
  - Java
  - MyBatis
  - ORM
---

This PR refines Serializable model class generation so that the generated code passes quality gate.

<!-- by making the SerialVerUID field the first field in the class and implement Serializable only if no super class defined or it is not Serializable. -->


<!--more-->
