# Repair Ledger

A responsive repair-shop tracker for monthly repairs, customer payment status, supplier balances, supplier/tool/inventory expenses, technician profiles, cleared balance history, and net profit.

## Use the app

Open `index.html` in a browser. The app works on phone and desktop screens.

Your records are saved in the browser on the same device using local storage. Use **Export CSV** to back up or move the data, and **Import CSV** to restore it.

Repair records include customer name, device type, exact serial/IMEI, repair description, invoice amount, customer payment status, part source, and part cost.

The **Repairs** page has three sub-pages:

- **Waiting repair** for newly added repairs that still need work.
- **Ready pickup** for repairs finished and waiting for the customer.
- **Picked up / paid** for completed repairs collected by the customer.

When adding one device, you can add multiple repair lines for the same serial number. Each line has its own customer price and part cost, and the app totals them on the repair.

For each repair, choose whether parts came from a supplier or from shop inventory. Supplier parts appear in the supplier balance. Inventory parts appear in a separate inventory balance and can be marked paid or pending.

The top search bar works across the app. Type manually to find a customer, serial/IMEI, supplier, technician, device, repair item, or note, or use the filter beside it to focus the app on repairs, paid/pending items, supplier, inventory, technician, or shop data.

The dashboard shows current, uncleared balances. Use **Clear** on individual rows or **Clear current balances** to move the current month into the **Cleared Data** page. Clearing does not delete records; it marks them as settled so the dashboard starts fresh.

The **Cleared Data** page has its own dedicated view for cleared balances and can filter by all time, single day, week/range, month, date range, customer name, technician name, serial number, or device text. It calculates gross, collected, expenses, net, shop profit, and technician salary automatically for the filtered records.

The **Supplier** page has its own dedicated view for supplier parts and payments. It shows supplier parts used in repairs, payments made to suppliers, totals paid, remaining supplier balance, payment dates, repair items, customer/device details, and date/search filters.

Repair, supplier, expense, technician, and cleared-data pages include search and date filters. Repairs can also be filtered by customer payment status, supplier/inventory source, and paid/pending part balances. Expenses can be filtered to supplier payments or inventory. Cleared Data can focus on shop, supplier, inventory, technician, or repair data.

Expense records can be general business expenses or linked to a specific repair. Use **Supplier payment** with a related supplier repair to reduce the remaining supplier balance for the parts used in that repair.

The **Technicians** tab tracks what the shop owes each technician and what each technician owes the shop. Enter the reason, total amount, paid amount, and the app calculates the remaining balance.

Technicians are managed as profiles. Repairs can be assigned to a technician profile; if none is selected, they go to the default technician profile. Technician salary share, advances, technician-owes-shop balances, and shop-owes-technician balances are calculated per profile.

Use **Add technician profile** to create another technician. Use **Add balance / advance** or the Balance/Advance buttons in a profile row to add money the shop owes the technician, money the technician owes the shop, or salary advances. Advances reduce the technician's salary due automatically.

The **Profit** tab splits positive net income 50/50 between shop profit and technician income. If the technician owes money to the shop, that debt is subtracted from the technician half first. The remaining technician half becomes salary due from the shop.

Use the invoice button on a repair row to print a customer invoice.

## Put it on the internet

This is a static web app, so it can be hosted by services like GitHub Pages, Netlify, Vercel, Cloudflare Pages, or any normal web hosting account. Upload `index.html` and open the hosted URL from your phone or computer.

## Supabase database and login

The app is ready for Supabase Auth and database storage.

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
