# Privacy Policy Publishing

This repository now includes a static legal microsite under `site/`:

- `site/index.html`
- `site/privacy-policy/index.html`
- `site/terms/index.html`

Use it to publish a public HTTPS privacy policy URL before App Store and Google Play submission.

## Recommended URL Shape

- `https://your-domain.example/privacy-policy/`
- `https://your-domain.example/terms/`

Within the deployed static site, the privacy policy route is `/privacy-policy/`
because it is backed by `site/privacy-policy/index.html`.

## Fastest Hosting Options

### GitHub Pages

1. Push this repository to GitHub.
2. Use `.github/workflows/pages.yml` to deploy `site/` to GitHub Pages.
3. In GitHub: `Settings > Pages > Source = GitHub Actions`.
4. After the first successful Pages deployment, use the resulting HTTPS URLs in:
   - App Store Connect
   - Google Play Console
   - in-app support and legal contact materials

If you use standard project Pages, the privacy policy URL will typically look like:

- `https://<github-user>.github.io/<repository>/privacy-policy/`

If you use a custom domain or user/organization Pages root, it can be:

- `https://your-domain.example/privacy-policy/`

### Netlify / Vercel

1. Create a new static site from this repository.
2. Set the publish directory to `site`.
3. Deploy and copy the public HTTPS URLs.

## Store Readiness Notes

- The public policy must remain accessible without login.
- The text must match the in-app privacy policy, terms, and consent wording.
- Update the support email and legal entity details before publishing.
- If your production build supports email account creation on iOS, confirm in-app account deletion before submission.
