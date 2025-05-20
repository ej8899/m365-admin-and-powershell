import { BaseClientSideWebPart } from "@microsoft/sp-webpart-base";

export interface ICyberTipBannerWebPartProps {}

export default class CyberTipBannerWebPart extends BaseClientSideWebPart<ICyberTipBannerWebPartProps> {

  // Fallback tips (in case external JSON fails)
  private fallbackTips = [
  {
    "title": "🔐 Don’t reuse passwords.",
    "message": "Each account should have its own password — if one is hacked, others stay safe."
  },
  {
    "title": "⚠️ Suspicious email? Don’t click.",
    "message": "Hover over links, check the sender, and when in doubt — report it."
  },
  {
    "title": "🛡️ Turn on 2FA everywhere.",
    "message": "Two-factor authentication adds an extra layer hackers hate."
  },
  {
    "title": "📶 Public Wi-Fi isn't safe for private stuff.",
    "message": "Avoid logging into banking or work accounts on open networks."
  },
  {
    "title": "💸 Urgent emails asking for money?",
    "message": "That’s a red flag. Always verify requests in person or by phone."
  },
  {
    "title": "🚨 See a weird pop-up warning you of a virus?",
    "message": "It’s probably fake. Don’t click — close the browser tab instead."
  },
  {
    "title": "🔒 Lock your screen when you leave.",
    "message": "It only takes a second — and keeps prying eyes away."
  },
  {
    "title": "🔄 Keep software up to date.",
    "message": "Updates fix bugs that hackers love to exploit."
  },
  {
    "title": "🎣 Phishing emails try to trick you.",
    "message": "Watch for misspellings, strange requests, or generic greetings."
  },
  {
    "title": "📝 Don’t save passwords in a text file or sticky note.",
    "message": "Use a password manager to store them securely."
  },
  {
    "title": "💾 Unknown USB drive? Don’t plug it in.",
    "message": "It could be booby-trapped with malware — report it to IT."
  },
  {
    "title": "📸 Think before you post.",
    "message": "Avoid sharing work info or personal details on social media."
  },
  {
    "title": "🔑 Use strong, weird passwords.",
    "message": "Random words like “BatteryTigerCake7!” are way harder to guess."
  },
  {
    "title": "🔁 Restart your devices weekly.",
    "message": "It applies updates and keeps things running smoothly."
  },
  {
    "title": "👥 Cybersecurity is everyone’s job.",
    "message": "Being cautious online helps protect the entire organization."
  },
  {
    "title": "🚧 If it seems too good to be true...",
    "message": "…it probably is. Scammers rely on urgency and excitement."
  },
  {
    "title": "📱 Review app permissions regularly.",
    "message": "Many apps collect more than they need — clean them out."
  },
  {
    "title": "🗂️ Don’t ignore backups.",
    "message": "Ransomware can lock your files — backups help you recover."
  },
  {
    "title": "📞 Got a weird message from “IT”?",
    "message": "Call the helpdesk — don’t trust links or urgent messages blindly."
  },
  {
    "title": "⚙️ Don’t install software without approval.",
    "message": "Even free apps can hide security risks."
  },
  {
    "title": "📴 Bluetooth off = one less open door.",
    "message": "Turn it off when you’re not using it — especially in public."
  },
  {
    "title": "✉️ Check the sender address, not just the name.",
    "message": "Hackers often impersonate people you trust."
  },
  {
    "title": "🧹 Clean out old accounts.",
    "message": "Unused logins can be weak links — close what you don’t use."
  },
  {
    "title": "🙅‍♂️ Don’t share your password with coworkers.",
    "message": "Even trusted teammates should have their own access."
  },
  {
    "title": "💬 Got a cyber tip to share?",
    "message": "We all learn from each other — pass it along to the team!"
  },
  {
    "title": "🔍 Hover before you click.",
    "message": "Hover over links to preview the destination — don’t get phished!"
  },
  {
    "title": "🧠 Stop and think before clicking.",
    "message": "Scammers rely on impulse — pausing gives you power."
  },
  {
    "title": "📵 Don’t trust random QR codes.",
    "message": "They can lead to fake sites or malicious downloads."
  },
  {
    "title": "🔐 Change default passwords.",
    "message": "Routers and devices with default logins are easy targets."
  },
  {
    "title": "🗃️ Back up your data regularly.",
    "message": "Cloud or external drive — don’t wait until it’s too late."
  },
  {
    "title": "🔓 Don’t use ‘123456’ or ‘password’.",
    "message": "Attackers try common passwords first — get creative."
  },
  {
    "title": "🚫 Don’t click unsubscribe in spam.",
    "message": "That link may confirm your address to a scammer."
  },
  {
    "title": "📲 Keep your phone updated.",
    "message": "Mobile security matters — install updates when prompted."
  },
  {
    "title": "📤 Don’t email sensitive info.",
    "message": "Use approved tools for secure document sharing."
  },
  {
    "title": "📅 Review account activity.",
    "message": "Look for unusual logins or devices on your accounts."
  },
  {
    "title": "🔧 Keep your antivirus on and updated.",
    "message": "It’s not perfect — but it’s a strong first line of defense."
  },
  {
    "title": "🔗 Shortened links can hide danger.",
    "message": "If unsure, use a link expander before clicking."
  },
  {
    "title": "🛑 Trust your gut — it’s a security tool.",
    "message": "If something feels off, report it or double-check."
  },
  {
    "title": "👀 Be careful with browser extensions.",
    "message": "Only install trusted ones — some steal data."
  },
  {
    "title": "💼 Use work devices for work only.",
    "message": "Mixing personal use increases risk to company data."
  },
  {
    "title": "🧑‍💻 Don’t use admin accounts for daily tasks.",
    "message": "Fewer privileges means fewer risks."
  },
  {
    "title": "🔐 Encrypt sensitive files.",
    "message": "If lost or stolen, encryption keeps data safe."
  },
  {
    "title": "👓 Use privacy screens in public.",
    "message": "Keep prying eyes off your work when on the go."
  },
  {
    "title": "📍 Don’t overshare your location online.",
    "message": "It can reveal more than you intend — even at home."
  },
  {
    "title": "💣 Don’t ignore browser warnings.",
    "message": "Security alerts exist for a reason — take them seriously."
  },
  {
    "title": "📤 Log out of accounts on shared computers.",
    "message": "Closing the browser isn’t always enough."
  },
  {
    "title": "📁 Keep your desktop clean.",
    "message": "Don’t leave sensitive files lying around unprotected."
  },
  {
    "title": "📶 Turn off Wi-Fi when not needed.",
    "message": "It reduces exposure to rogue access points."
  },
  {
    "title": "🧾 Read before accepting app permissions.",
    "message": "Why does that flashlight app need your contacts?"
  },
  {
    "title": "🎯 Cybercriminals don’t target only techies.",
    "message": "Anyone can be a target — that’s why awareness matters."
  }
];


  private tipsToUse: any[] = [];
  private currentIndex: number = 0;

  public async render(): Promise<void> {
  const tips = await this.fetchTips();
  this.tipsToUse = tips && tips.length > 0 ? tips : this.fallbackTips;
  this.currentIndex = Math.floor(Math.random() * this.tipsToUse.length);

  this.renderTip();
}

private renderTip(): void {
  const tip = this.tipsToUse[this.currentIndex];

  const container = document.createElement("div");
  container.style.padding = "1rem";
  container.style.backgroundColor = "#2E3440";
  container.style.color = "#ECEFF4";
  container.style.border = "3px solid #81A1C1";
  container.style.fontFamily = "'Courier New', monospace";
  container.style.fontSize = "1rem";
  container.style.width = "100%";
  container.style.maxWidth = "800px";
  container.style.margin = "1rem auto";
  container.style.boxShadow = "5px 5px 0 #81A1C1";
  container.style.textAlign = "left";
  container.style.position = "relative";

  const title = document.createElement("div");
  title.textContent = tip.title;
  title.style.fontWeight = "bold";
  title.style.fontSize = "1.2rem";
  title.style.marginBottom = "0.5rem";

  const message = document.createElement("div");
  message.textContent = tip.message;

  const nav = document.createElement("div");
  nav.style.position = "absolute";
  nav.style.bottom = "0.5rem";
  nav.style.right = "1rem";
  nav.style.fontSize = "1.1rem";
  nav.style.cursor = "pointer";
  nav.style.userSelect = "none";

  const prev = document.createElement("span");
  prev.textContent = "◀";
  prev.style.marginRight = "1rem";
  prev.onclick = () => this.navigateTip(-1);

  const next = document.createElement("span");
  next.textContent = "▶";
  next.onclick = () => this.navigateTip(1);

  nav.appendChild(prev);
  nav.appendChild(next);

  container.appendChild(title);
  container.appendChild(message);
  container.appendChild(nav);

  this.domElement.innerHTML = "";
  this.domElement.appendChild(container);
}

private navigateTip(direction: number): void {
  const total = this.tipsToUse.length;
  this.currentIndex = (this.currentIndex + direction + total) % total;
  this.renderTip();
}


  private async fetchTips(): Promise<any[]> {
    try {
      const response = await fetch("https://<yourtenant>.sharepoint.com/sites/<yoursite>/SiteAssets/tips.json", {
        headers: { "Accept": "application/json" }
      });
      if (!response.ok) throw new Error("Bad response");
      return await response.json();
    } catch (error) {
      console.warn("Failed to load external tips, using fallback tips.", error);
      return [];
    }
  }
}
