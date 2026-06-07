# Repair Ledger

A responsive repair-shop tracker for monthly repairs, customer payment status, supplier balances, supplier/tool/inventory expenses, technician profiles, cleared balance history, and net profit.

## Use the app

Open `index.html` in a browser. The app works on phone and desktop screens.

When signed in, records are saved to Supabase and recent records are also cached in the browser. Supabase remains the permanent source of truth, so the smaller browser cache cannot stop long-term database saves. Use **Export CSV** for an additional backup and **Import CSV** to restore it.

Repair records include customer name, device type, exact serial/IMEI, repair description, invoice amount, customer payment status, part source, and part cost.

The **Repairs** page has three sub-pages:

- **Waiting repair** for newly added repairs that still need work.
- **Ready pickup** for repairs finished and waiting for the customer.
- **Picked up / paid** for completed repairs collected by the customer.

If there is only one technician profile, repairs are assigned to that technician automatically and the repair selection controls stay hidden. If there is more than one technician profile, the **Repairs** page shows row checkboxes so you can select multiple visible repairs, choose a technician, and press **Assign technician**.

When adding one device, you can add multiple repair lines for the same serial number. Each line has its own customer price and part cost, and the app totals them on the repair.

For each repair, choose whether parts came from a supplier or from shop inventory. Supplier parts appear in the supplier balance. Inventory parts appear in a separate inventory balance and can be marked paid or pending.

The **Inventory** page has **Payments & balances** and **Stock** sub-pages. Stock records include brand, model, part name, quantity, purchase cost, supplier/source, and paid or pending status. Search finds stock by brand, model, or part, and filters show available or out-of-stock items.

Complete donor phones use an editable common-parts checklist. Select all usable parts or add custom parts. When a repair uses a donor-phone part, only that selected part is removed from availability.

When a repair uses normal stock, one item is deducted automatically. A paid stock purchase gives the repair a €0 part cost. A pending stock purchase shows the unit-cost reference on the repair, while the actual outstanding debt stays only on the stock purchase to avoid counting the same cost twice.

Waiting repairs do not count toward invoiced money or customer pending balances until they are moved to **Ready pickup** or **Picked up / paid**. Waiting repair part costs only affect supplier or inventory balances when **Parts acquired / cost active** is checked. Moving a repair to ready or picked up treats its parts as acquired automatically.

The top search bar works across the app. Type manually to find a customer, serial/IMEI, supplier, technician, device, repair item, or note, or use the filter beside it to focus the app on repairs, paid/pending items, supplier, inventory, technician, or shop data.

Search and filter controls are minimized into icon buttons. Press the search icon to open the search field, and press the filter icon to open the filter fields for that page.

Use the three-dot menu button in the left menu to minimize the menu and give the selected page more screen space. Press it again to open the full menu.

The dashboard shows all current, uncleared balances no matter which month the records came from. Use **Clear** on individual rows or **Clear current balances** to move those balances into the **All Time Income** page. Clearing asks for a folder start date and end date; the start date defaults from the paid/picked records being cleared, and the end date can be today, yesterday, or a custom date. Clearing does not delete records; it marks them as settled so the dashboard starts fresh. Clearing a repair also clears its linked supplier payments and linked expenses so old repair income and old repair costs stay together.

Dashboard metric cards are clickable. For example, **Paid expenses** opens the paid expense records, **Customer pending** opens unpaid customer repairs, and **Supplier remaining** opens the supplier balance page.

The dashboard's **Today updates** panel stores each data-changing action in Supabase, remains available after closing and reopening the app, and refreshes changes made by other signed-in devices.

The **All Time Income** page has its own dedicated view for cleared balances and can filter by all time, single day, week/range, month, date range, customer name, technician name, serial number, or device text. It groups cleared balances into expandable folders with start date, end date, gross, expense, and net totals. Cleared rows can be restored, edited, or deleted, and folder dates can be edited.

The **Supplier** page has its own dedicated view for supplier parts and payments. It shows supplier parts used in repairs, payments made to suppliers, totals paid, remaining supplier balance, payment dates, repair items, customer/device details, and date/search filters. Use **Pay selected** for one or more supplier items, or **Pay all acquired** to automatically pay every acquired supplier part and pending supplier expense at once. Supplier rows can be edited or deleted after payment if a mistake is found, and **Edit paid** lets you correct the total paid amount for a supplier part.

Repair, supplier, expense, technician, and all-time income pages include search and date filters. Repairs can also be filtered by customer payment status, supplier/inventory source, and paid/pending part balances. Expenses can be filtered to supplier payments or inventory. All Time Income can focus on shop, supplier, inventory, technician, or repair data.

Expense records can be general business expenses or linked to a specific repair. Use **Supplier payment** with a related supplier repair to reduce the remaining supplier balance for the parts used in that repair.

Use **Supplier expense** for independent supplier costs that should increase the supplier balance when pending. Use **Inventory** for independent inventory costs that should increase the inventory balance when pending. Other pending expenses appear as **Expense remaining** on the dashboard. Paid expenses deduct from net cash; pending expenses stay visible as balances until paid or cleared.

The **Technicians** tab tracks what the shop owes each technician and what each technician owes the shop. Enter the reason, total amount, paid amount, and the app calculates the remaining balance.

Technicians are managed as profiles. Repairs can be assigned to a technician profile; if none is selected, they go to the default technician profile. Technician salary share, advances, technician-owes-shop balances, and shop-owes-technician balances are calculated per profile.

Use **Add technician profile** to create another technician. Use **Add balance / advance** or the Balance/Advance buttons in a profile row to add money the shop owes the technician, money the technician owes the shop, or salary advances. Advances reduce the technician's salary due automatically.

The **Profit** tab splits positive net income 50/50 between shop profit and technician income. If the technician owes money to the shop, that debt is subtracted from the technician half first. The remaining technician half becomes salary due from the shop.

Use the invoice button on a repair row to print a customer invoice.

## Put it on the internet

This is a static web app, so it can be hosted by services like GitHub Pages, Netlify, Vercel, Cloudflare Pages, or any normal web hosting account. Upload `index.html` and open the hosted URL from your phone or computer.

## Android APK

The app can also be built as an Android APK with Capacitor. The Android app uses the same `index.html` and the same Supabase database, so web and Android records stay connected to the same stored data.

Portable build tools were installed under:

```text
C:\Users\Sayed\Downloads\repair-apk-tools
```

After changing `index.html`, rebuild the APK with:

```cmd
build-apk.cmd
```

Or with PowerShell if scripts are enabled:

```powershell
.\build-apk.ps1
```

The debug APK is created at:

```text
android\app\build\outputs\apk\debug\app-debug.apk
```

Install that APK on an Android phone to use the mobile app. For store release later, build a signed release APK or AAB instead of the debug APK.

## Supabase database and login

The app is ready for Supabase Auth and database storage.

The strict-authentication build does not persist Supabase sessions. Every page
refresh, browser reopen, or app restart requires email and password again.
Signing out clears all local app state.

Before deploying the strict-authentication build, follow
`supabase-auth-migration-plan.md`, export the required backups, review existing
user roles, and then run `supabase-auth-admin-migration.sql`. Run the migration
before uploading the updated `index.html`; otherwise existing accounts cannot
load their required profile.

The migration adds an admin portal and `admin`, `employee`, and `decoy` profile
roles. Admins can manage employee/decoy access and force logout open sessions.
Decoy and inactive users are blocked from `repair_records` by Supabase RLS.
Admin accounts are protected from client-side role removal or disablement.

No Supabase service-role key is used in the frontend.

1. Create a Supabase project.
2. In Supabase, open **SQL Editor** and run `supabase-schema.sql`.
3. In Supabase **Authentication**, enable email/password sign-in.
4. Sign up with your owner email in the app.
5. In Supabase **Authentication > Users**, copy your user UUID.
6. Run the owner insert shown at the bottom of `supabase-schema.sql`.
7. In `index.html`, paste your project values:

```js
const SUPABASE_URL = "https://YOUR-PROJECT.supabase.co";
const SUPABASE_ANON_KEY = "YOUR-ANON-PUBLIC-KEY";
```

8. Host `index.html` online.

To give another person access, let them create an account, copy their user UUID from Supabase, then insert them into `app_members` as `writer` or `reader`.

When Supabase is configured and the user is approved in `app_members`, repair records are loaded from and saved to the database. Deleting a row in the app deletes it from the database.

## Git executable path

Git is not currently installed or available on this machine's PATH. I checked:

- `where.exe git`
- `git --version`
- `C:\Program Files\Git\cmd\git.exe`
- `C:\Program Files\Git\bin\git.exe`
- `C:\Users\Sayed\AppData\Local\Programs\Git\cmd\git.exe`

After installing Git for Windows, the usual executable path is:

```text
C:\Program Files\Git\cmd\git.exe
```

Add this folder to PATH:

```text
C:\Program Files\Git\cmd
```
