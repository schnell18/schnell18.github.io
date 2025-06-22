---
title: 'A Mixed Quantization Approach for Data-Free Quantization of LLMs'

# Authors
# If you created a profile for a user (e.g. the default `admin` user), write the username (folder name) here
# and it will be replaced with their full name and linked to their profile.
authors:
  - admin
  - Yanbin Liu
  - Weihua Li
  - Xiaodan Wang
  - Quan Bai

# Author notes (optional)
author_notes:
  - 'Equal contribution'
  - 'Equal contribution'

date: '2025-02-23T00:00:00Z'
publishDate: "2025-06-20T00:00:00Z"
doi: '10.5220/0013159100003890'

# Schedule page publish date (NOT publication's date).
# publishDate: '2017-01-01T00:00:00Z'

# Publication type.
# Accepts a single type but formatted as a YAML list (for Hugo requirements).
# Enter a publication type from the CSL standard.
publication_types: ['paper-conference']

# Publication name and optional abbreviated publication name.
publication: In *17th International Conference on Agents and Artificial Intelligence*
publication_short: In *ICAART 2025*

abstract: Large Language Models (LLMs) have demonstrated significant capabilities in intelligent activities such as natural language comprehension, content generation, and knowledge retrieval. However, training and deploying these models require substantial computation resources, setting up a significant barrier for developing AI applications and conducting research. Various model compression techniques have been developed to address the demanding computational resource issue. Nonetheless, there has been limited exploration into high-level quantization strategy to offer better flexibility of balancing the trade-off between memory usage and accuracy. We propose an effective mixed-quantization method named MXQ to bridge this research gap for a better memory-accuracy balance. Specifically, we observe that the weight distributions of LLMs vary considerably from layer to layer, resulting in different tolerances to quantization errors. Motivated by this, we derive a novel quantization optimisation formulation to solve for the layer-wise quantization parameters, while enforcing the overall quantization memory consumption budget into the constraints. The new formulation can be efficiently solved by converting to a mixed integer programming problem. Experiments shows that our method can achieve the 1% accuracy loss goal with additional bit budget or further reduce memory usage on Llama models. This unlocks a wide range of quantization options and simplifies memory-accuracy trade-off.

# Summary. An optional shortened abstract.
summary: We propose MXQ to optimise quantization accuracy while enforcing the overall quantization memory consumption. Experiments shows that our method can achieve the 1% accuracy loss goal with additional bit budget or further reduce memory usage on Llama models.

tags:
  - Large Language Models
  - Linear Programming
  - LLM Quantization

# Display this page in the Featured widget?
featured: true

# Custom links (uncomment lines below)
links:
  - name: View Paper
    url: /papers/mxq/index.html

url_pdf: 'https://www.scitepress.org/Papers/2025/131591/131591.pdf'
url_code: 'https://github.com/schnell18/hqq'
url_dataset: 'https://www.kaggle.com/datasets/schnell18/mxq-quant-benchmark-results-on-llama'
url_slides: /slides/mxq/index.html
# url_video: 'https://youtube.com'

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
image:
  caption: 'Image credit: [**scitepress**](https://www.scitepress.org/Papers/2025/131591/131591.pdf)'
  focal_point: ''
  preview_only: false

# Associated Projects (optional).
#   Associate this publication with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `internal-project` references `content/project/internal-project/index.md`.
#   Otherwise, set `projects: []`.
projects:
  - example

# Slides (optional).
#   Associate this publication with Markdown slides.
#   Simply enter your slide deck's filename without extension.
#   E.g. `slides: "example"` references `content/slides/example/index.md`.
#   Otherwise, set `slides: ""`.
slides: ""
---

{{% callout note %}}
This paper is converted to HTML with identical viewing experience as its PDF
counterpart. To read this paper in your browser, click VIEW PAPER. If you wish
to stick with the PDF
version, click the PDF link above.
{{% /callout %}}
