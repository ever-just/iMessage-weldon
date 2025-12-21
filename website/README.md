# WELDON.VIP Website

Simple static website for App Store submission requirements.

## Files

- `index.html` - Marketing/landing page
- `privacy.html` - Privacy policy (required for App Store)
- `support.html` - Support/FAQ page (required for App Store)

## Deployment

Deploy to any static hosting service:

### Option 1: GitHub Pages (Free)
1. Create a new repo `weldon-vip-website`
2. Push these files
3. Enable GitHub Pages in repo settings
4. Custom domain: `weldon.vip`

### Option 2: Netlify (Free)
1. Drag and drop the `website` folder to Netlify
2. Configure custom domain: `weldon.vip`
3. URLs will be:
   - https://weldon.vip
   - https://weldon.vip/privacy
   - https://weldon.vip/support

### Option 3: Vercel (Free)
```bash
cd website
vercel --prod
```

## Required URLs for App Store Connect

- **Privacy Policy URL**: https://weldon.vip/privacy
- **Support URL**: https://weldon.vip/support
- **Marketing URL**: https://weldon.vip (optional)

## Local Testing

```bash
cd website
python3 -m http.server 8000
# Visit http://localhost:8000
```
