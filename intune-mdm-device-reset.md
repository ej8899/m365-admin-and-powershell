# 📋 Intune Laptop Reassignment Checklist (Cloud-Only Environment)

Use this guide to cleanly prepare an Intune-managed Windows laptop for a **new user** in a **Microsoft 365 cloud-only** environment. This ensures **no prior user data**, policies, or Intune associations are retained.

---

## ✅ Step-by-Step Instructions

1. **Go to Intune Admin Center** → `Devices` → `Windows` → find the device.
2. Click **Wipe**.
3. In the wipe prompt, select:
   - ✅ `Wipe device, and continue to wipe even if device loses power`
   - ❌ **Do NOT select** "Retain enrollment state and associated user account"
4. Confirm the wipe and allow the device to complete reset (can take several minutes).
5. Once wiped:
   - Go to **Microsoft Entra Admin Center** → `Devices` → search for the device → **Delete** it.
   - Return to **Intune Admin Center** → `Devices` → find the same device → **Delete** it here too.
6. **Hand over the device to the new user**.
7. New user logs in with **Microsoft 365 credentials**.
8. The device **auto-joins Azure AD**, **auto-enrolls in Intune**, and receives **assigned apps and policies**.

---

## ℹ️ Notes

- This is a **secure factory reset** — not a format or reimage.
- No USB or imaging required — device uses built-in reset.
- You'll get a **clean slate** with no trace of the previous user.

---

## 🔄 Reset Method Comparison

| Method              | Description                                                                                 | Retains User? | Requires Rebuilding? |
|---------------------|---------------------------------------------------------------------------------------------|---------------|-----------------------|
| **Wipe**            | Full reset to OOBE. Removes all user data, apps, settings. Cleanest for new user setup.     | ❌ No         | ❌ No                 |
| **Autopilot Reset** | Resets and reapplies Autopilot profile. Removes user data but keeps device enrolled.        | ❌ No         | ❌ No                 |
| **Fresh Start**     | Removes bloatware and reinstalls Windows while keeping user data and MDM enrollment.        | ✅ Yes        | ❌ No                 |

> 🔐 **Recommended for new user handoff: Use Wipe**, then delete the device from both **Entra ID** and **Intune** for a completely fresh start.

---

