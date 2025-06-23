---
title: "Towards Superior Quantization Accuracy: A Layer-sensitive Approach"
authors:
  - admin
  - Yanbin Liu
  - Weihua Li
  - Jie Lv
  - Xiaodan Wang
  - Quan Bai
date: "2025-03-09T00:00:00Z"
doi: "10.48550/arXiv.2503.06518"

# Schedule page publish date (NOT publication's date).
publishDate: "2025-06-21T00:00:00Z"

# Publication type.
# Accepts a single type but formatted as a YAML list (for Hugo requirements).
# Enter a publication type from the CSL standard.
publication_types: ["article"]

# Publication name and optional abbreviated publication name.
publication: ""
publication_short: ""

abstract: Large Vision and Language Models have exhibited remarkable human-like intelligence in tasks such as natural language comprehension, problem-solving, logical reasoning, and knowledge retrieval. However, training and serving these models require substantial computational resources, posing a significant barrier to their widespread application and further research. To mitigate this challenge, various model compression techniques have been developed to reduce computational requirements. Nevertheless, existing methods often employ uniform quantization configurations, failing to account for the varying difficulties across different layers in quantizing large neural network models. This paper tackles this issue by leveraging layer-sensitivity features, such as activation sensitivity and weight distribution Kurtosis, to identify layers that are challenging to quantize accurately and allocate additional memory budget. The proposed methods, named SensiBoost and KurtBoost, respectively, demonstrate notable improvement in quantization accuracy, achieving up to 9% lower perplexity with only a 2% increase in memory budget on LLama models compared to the baseline.

# Summary. An optional shortened abstract.
summary: This paper leverages activation sensitivity and weight distribution Kurtosis to guide bit budget allocation. The proposed SensiBoost and KurtBoost demonstrate notable improvement in quantization accuracy, achieving up to 9% lower perplexity with only a 2% increase in memory budget on LLama models compared to the baseline.

tags:
- Large Language Models
- Linear Programming
- LLM Quantization

featured: true

links:
  - name: View Paper
    url: /papers/sensi-kurt-boost/index.html
url_pdf: 'https://arxiv.org/pdf/2503.06518'
url_code: 'https://github.com/schnell18/lm-quant-toolkit'
url_dataset: 'https://huggingface.co/datasets/schnell18/branch-of-science'
# url_poster: '#'
# url_project: ''
# url_slides: ''
# url_source: '#'
# url_video: '#'

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
image:
  caption: 'Image credit: [**arXiv**](https://arxiv.org/abs/2503.06518#)'
  focal_point: ""
  preview_only: false

# Associated Projects (optional).
#   Associate this publication with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `internal-project` references `content/project/internal-project/index.md`.
#   Otherwise, set `projects: []`.
projects:
- internal-project

# Slides (optional).
#   Associate this publication with Markdown slides.
#   Simply enter your slide deck's filename without extension.
#   E.g. `slides: "example"` references `content/slides/example/index.md`.
#   Otherwise, set `slides: ""`.
slides: ""
---

This work is a follow-up research on top of my [previous
paper](/publication/mxq/) on LLMs.

{{% callout note %}}
This site hosts an HTML version of the original paper which was converted using
[pdf2htmlex](https://pdf2htmlex.github.io/pdf2htmlEX/). We recommend you read
the HTML version of the paper by clicking [_VIEW
PAPER_](/papers/sensi-kurt-boost/index.html) as it loads faster and replicates
identical typography quality as its PDF counterpart. If you wish to stick with
the PDF version, click the [_PDF_](https://arxiv.org/pdf/2503.06518) link
above.
{{% /callout %}}

