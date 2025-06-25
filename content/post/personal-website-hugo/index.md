---
title: "🧠 Build a personal website with just two dollars"
summary: Explains how to setup a website for online presence and personal branding by leveraging open-source tool, low-cost domain registration, and free hosting.
date: 2025-06-25
draft: false
authors:
  - admin
tags:
  - Hugo
  - Personal Brand
  - Website
  - namecheap
  - github pages
  - Markdown
image:
  caption: 'Sunset on Mount Eden'
---
## Introduction

Creating a personal website has never been more accessible or affordable. This comprehensive guide will walk you through building a professional website using Hugo, GitHub Pages, and Namecheap—a cost-effective combination that delivers excellent performance with annual cost as low as two dollars.

## Why This Technology Stack?

### Hugo: The Static Site Generator Champion

Hugo stands out among static site generators for several compelling reasons:

- **Lightning-fast generation**: Hugo can build thousands of pages in seconds, making it ideal for both small personal sites and large content-heavy websites
- **Abundant themes**: The Hugo community has created hundreds of beautiful, responsive themes available at [themes.gohugo.io](https://themes.gohugo.io)
- **Responsive design**: Most Hugo themes are mobile-first, ensuring your site looks great on PC, tablet, and phone
- **SEO-friendly**: Hugo generates clean HTML with proper semantic structure, making it easy for search engines to index your content
- **No database required**: Static sites are inherently more secure and faster than dynamic alternatives

### GitHub Pages: Free, Reliable Hosting

GitHub Pages offers compelling advantages for personal websites:

- **Free hosting**: No monthly fees for public repositories
- **Automatic deployments**: Push to your repository and your site updates automatically
- **Custom domain support**: Use your own domain name for free
- **99.9% uptime**: Backed by GitHub's robust infrastructure
- **Global CDN**: Content delivery network ensures fast loading worldwide

### Namecheap: Affordable Domain Registration

Namecheap provides excellent value for domain registration:

- **Competitive pricing**: Often significantly cheaper than competitors
- **Free privacy protection**: Included with most domains to protect your personal information
- **User-friendly interface**: Easy-to-use control panel for DNS management
- **Reliable customer support**: 24/7 support when you need assistance

Since domain registration is the only source of cost in our solution, to keep
the overall cost low we have to trade-off the choice of TLD. The table below
presents the price for various TLD on Namecheap.

| TLD | Annual Cost (Namecheap) | Renewal Cost | Best For | Considerations |
|-----|------------------------|--------------|----------|----------------|
| .com | $8.88 | $12.98 | Personal/Business | Most trusted, universal recognition |
|.xyz | $1.98 | $11.98 |Budget-conscious | Very affordable first year, mixed reputation|
| .net | $10.98 | $14.98 | Tech professionals | Good alternative to .com |
| .org | $10.98 | $14.98 | Non-profits/Personal | Implies organization/community |
| .io | $35.88 | $54.88 | Tech/Startups | Trendy but expensive |
| .me | $18.88 | $19.98 | Personal branding | Perfect for personal sites |
| .dev | $12.98 | $17.98 | Developers | Google-owned, requires HTTPS |
| .tech | $48.88 | $54.88 | Technology sites | Descriptive but costly |
| .blog | $29.98 | $32.98 | Bloggers | Clear purpose, moderate cost |

{{% callout note %}}
*Prices as of 2024/2025 and may vary with promotions*
{{% /callout %}}

## High-Level Procedure

### Phase 1: Domain and Hosting Setup
1. Purchase domain from Namecheap
2. Create GitHub repository
3. Configure DNS settings

### Phase 2: Hugo Development
1. Install Hugo locally
2. Choose and customize theme
3. Create content
4. Test locally

### Phase 3: Deployment and Optimization
1. Deploy to GitHub Pages
2. Set up Google Search Console
3. Optimize for search engines

## Detailed Implementation Guide

### Step 1: Domain Registration and DNS Configuration

1. **Purchase your domain** from [Namecheap](https://www.namecheap.com)
2. **Navigate to DNS settings** in your Namecheap dashboard
3. **Add the following DNS records**:

#### A Records (IPv4)
Point your domain to GitHub Pages IPv4 addresses:

| Type | Host | Value | TTL |
|------|------|-------|-----|
| A | @ | 185.199.108.153 | Automatic |
| A | @ | 185.199.109.153 | Automatic |
| A | @ | 185.199.110.153 | Automatic |
| A | @ | 185.199.111.153 | Automatic |

#### AAAA Records (IPv6)
For IPv6 support:

| Type | Host | Value | TTL |
|------|------|-------|-----|
| AAAA | @ | 2606:50c0:8000::153 | Automatic |
| AAAA | @ | 2606:50c0:8001::153 | Automatic |
| AAAA | @ | 2606:50c0:8002::153 | Automatic |
| AAAA | @ | 2606:50c0:8003::153 | Automatic |

#### CNAME Record
For www subdomain:

| Type | Host | Value | TTL |
|------|------|-------|-----|
| CNAME | www | yourusername.github.io | Automatic |

#### TXT Record for GitHub Domain Verification

| Type | Host | Value | TTL |
|------|------|-------|-----|
| TXT | *provided by github* | *provided by github* | Automatic |

{{% callout note %}}
**Important for New Zealand users**: DNS propagation can take 24-48 hours in New Zealand due to the geographic distance from major DNS servers and internet infrastructure hubs. Be patient and use tools like [whatsmydns.net](https://www.whatsmydns.net) to check propagation status.
{{% /callout %}}

### Step 2: Hugo Installation and Setup

1. **Install Hugo** following the official guide at [gohugo.io/installation](https://gohugo.io/installation/)

2. **Create a new Hugo site**:
```bash
hugo new site my-website
cd my-website
```

3. **Choose a theme** from [themes.gohugo.io](https://themes.gohugo.io) and install it:
```bash
git init
git submodule add https://github.com/theme-author/theme-name.git themes/theme-name
```

4. **Configure your site** by editing `config.toml`:
```toml
baseURL = "https://yourdomain.com"
languageCode = "en-us"
title = "Your Site Title"
theme = "theme-name"
```

### Step 3: GitHub Repository Setup

1. **Create a repository** named `yourusername.github.io` on GitHub
2. **Add your Hugo site** to the repository
3. **Create a GitHub Action** for automatic deployment by adding `.github/workflows/hugo.yml`:

```yaml
name: Deploy Hugo site to Pages

on:
  push:
    branches: ["main"]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

defaults:
  run:
    shell: bash

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: recursive

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: 'latest'
          extended: true

      - name: Build
        run: hugo --minify

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v2
        with:
          path: ./public

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v2
```

### Step 4: Google Search Console Setup

1. **Visit** [Google Search Console](https://search.google.com/search-console/)
2. **Add your property** using your domain name
3. **Verify domain ownership** by adding a TXT record to your DNS:

```
Type: TXT
Host: @
Value: google-site-verification=your-google-verification-code
TTL: Automatic
```

4. **Submit your sitemap** at `https://yourdomain.com/sitemap.xml`
5. **Monitor** your site's search performance and indexing status

## Privacy and Content Guidelines

### Protecting Your Privacy

When adding personal photos to your website:

1. **Remove EXIF data** before uploading images. EXIF data can contain:
   - GPS coordinates (exact location where photo was taken)
   - Camera model and settings
   - Date and time stamps
   - Device information

2. **Use EXIF removal tools**:
   - **Desktop**: GIMP, Photoshop, or dedicated EXIF tools
   - **Command line 1**: `magick image.jpg -strip image.jpg`
   - **Command line 2**: `exiftool -all= image.jpg`

3. **Be mindful of background details** in photos that might reveal your location

{{% callout note %}}
The author leverages pre-commit hooks to remove EXIF automatically. Checkout [process-image.sh](https://github.com/schnell18/schnell18.github.io/blob/master/process-image.sh)
for details.
{{% /callout %}}



### Image Attribution and Copyright

Always respect copyright and give proper attribution:

1. **Use royalty-free sources**:
   - [Unsplash](https://unsplash.com) - Free high-quality photos
   - [Pexels](https://pexels.com) - Free stock photos and videos
   - [Pixabay](https://pixabay.com) - Free images, videos, and music

2. **Create an attribution section** in your site footer or dedicated page.
3. **Follow CC license requirements** for Creative Commons images
4. **Keep records** of image sources and licenses

### DNS Considerations for New Zealand Users

Due to New Zealand's geographic isolation from major internet infrastructure:

- **DNS propagation** typically takes 24-48 hours (vs 2-24 hours elsewhere)
- **Use local DNS servers** like 1.1.1.1 or 8.8.8.8 for faster resolution
- **Test from multiple locations** using tools like [whatsmydns.net](https://www.whatsmydns.net)
- **Consider CloudFlare** for additional CDN benefits if your site grows

## Reference

- **Hugo Documentation**: [gohugo.io/documentation](https://gohugo.io/documentation/)
- **GitHub Pages Documentation**: [docs.github.com/en/pages](https://docs.github.com/en/pages)
- **Namecheap Knowledge Base**: [www.namecheap.com/support/knowledgebase](https://www.namecheap.com/support/knowledgebase/)
- **Google Search Console Help**: [support.google.com/webmasters](https://support.google.com/webmasters)

## Conclusion

Building a personal website with Hugo, GitHub Pages, and Namecheap provides an excellent foundation for your online presence. This combination offers professional results at minimal cost while maintaining the flexibility to grow and evolve your site over time. The static site approach ensures fast loading times, strong security, and excellent search engine optimization—all crucial factors for success in today's digital landscape.

Remember that building a great website is an iterative process. Start with a simple design and gradually add features and content as you become more comfortable with the tools. Focus on creating valuable content for your visitors, and the technical aspects will become second nature over time.

<!-- Prompt: -->
<!---->
<!-- Compose a blog post to explain to how build a personal website using hugo, -->
<!-- github pages, and the low-cost domain registar namecheap. Explain the reasons -->
<!-- for this choice, for example, abundant themes, fast site generation, responsive -->
<!-- design that works on PC, phone and pad, SEO friendly, free hosting. Describe -->
<!-- the high level procedure and give proper reference to authoriative source. -->
<!-- Highlight how to protect privacy information such as geo location in author's -->
<!-- pictures, give credit to pictures from Internet in a section called final tips. -->
<!-- Present trade-offs of various TLD options and related cost in a table. Include -->
<!-- instructions to add A, AAAA records for github's IPV4, IPv6 addresses, CNAME to -->
<!-- username.github.io and an TXT record for github domain validation. Detail the -->
<!-- submission to Google Search Console section's with instructions to setup the TXT -->
<!-- record for google verification. Mentioning the fact that DNS refresh takes -->
<!-- longer in New Zealand for the reason of being located far from major -->
<!-- conntinents. Export the markdown as a single file. -->
