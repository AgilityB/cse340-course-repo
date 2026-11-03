# CSE 340 Week 01 — Design notes

## What changed
- Replaced `public/css/main.css` with responsive, mobile-first styles.
- Updated the EJS templates with semantic markup and accessible navigation.
- Kept all four routes, page-title variables, and reusable header/footer partials.
- Added `npm start` for hosting services such as Render.
- Removed invalid nested paragraph markup from pages.

## Understanding the CSS
- `:root` contains reusable design colors.
- `box-sizing: border-box` keeps padding inside element widths.
- `.header-inner` and `main` limit the reading width.
- `.card-grid` uses CSS Grid: one column on small screens, two at 650px, three at 950px.
- `:focus-visible` highlights keyboard focus, and the skip link helps keyboard users.
- `prefers-reduced-motion` respects users who request reduced motion.

## Check before submission
1. Run `npm install`, then `npm start`; visit `/`, `/organizations`, `/projects`, and `/categories`.
2. Confirm the images load and the mobile navigation works.
3. Commit and push the updated files to GitHub; never commit `.env`.
4. Deploy/redeploy on Render with build command `npm install` and start command `npm start`.
5. Test the live Render URL and use Lighthouse or another accessibility checker.

The ZIP excludes the `.git` folder and any `.env` file. Deployment and live-browser testing must be completed in your own environment.
