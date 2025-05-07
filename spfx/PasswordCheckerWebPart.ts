import { Version } from '@microsoft/sp-core-library';
import {
  type IPropertyPaneConfiguration,
  PropertyPaneTextField
} from '@microsoft/sp-property-pane';
import { BaseClientSideWebPart } from '@microsoft/sp-webpart-base';
import type { IReadonlyTheme } from '@microsoft/sp-component-base';
// Removed: import { escape } from '@microsoft/sp-lodash-subset'; // unused
// Removed: import styles from './PasswordCheckerWebPart.module.scss'; // unused
import * as strings from 'PasswordCheckerWebPartStrings';

export interface IPasswordCheckerWebPartProps {
  description: string;
}

export default class PasswordCheckerWebPart extends BaseClientSideWebPart<IPasswordCheckerWebPartProps> {

  public render(): void {
    this.domElement.innerHTML = `
      <div style="font-family:Segoe UI, sans-serif; max-width:400px;">
        <h3>🔐 Password Breach Check</h3>
        <input type="password" id="pwInput" placeholder="Enter password" style="width:100%; padding:8px; margin-bottom:8px; border:1px solid #ccc; border-radius:4px;" />
        <button id="checkBtn" style="padding:8px 12px; background:#0078d4; color:white; border:none; border-radius:4px; cursor:pointer;">Check Password</button>
        <div id="result" style="margin-top:10px;"></div>
      </div>
    `;

    this.domElement.querySelector('#checkBtn')?.addEventListener('click', async () => {
      const pwInput = this.domElement.querySelector('#pwInput') as HTMLInputElement;
      const password = pwInput?.value;

      if (!password) {
        alert("Please enter a password.");
        return;
      }

      try {
        const response = await fetch('https://ejmedia.ca/clients/COMPANY/passwordchecker.php', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ password })
        });

        const result = await response.json();
        const resultBox = this.domElement.querySelector('#result') as HTMLElement | null;

        if (resultBox) {
          resultBox.innerHTML = result.breached
            ? `<span style="color: red;">⚠️ ${result.message}</span>`
            : `<span style="color: green;">✅ Password not found in any known breaches.</span>`;
        }
      } catch (err) {
        console.error("API call failed:", err);
        const resultBox = this.domElement.querySelector('#result') as HTMLElement | null;
        if (resultBox) {
          resultBox.innerHTML = `<span style="color: darkorange;">⚠️ Error connecting to breach check service.</span>`;
        }
      }
    });
  }

  protected onInit(): Promise<void> {
    return this._getEnvironmentMessage().then(message => {
      // Removed unused: this._environmentMessage = message;
    });
  }

  private _getEnvironmentMessage(): Promise<string> {
    if (!!this.context.sdks.microsoftTeams) {
      return this.context.sdks.microsoftTeams.teamsJs.app.getContext()
        .then(context => {
          let environmentMessage: string = '';
          switch (context.app.host.name) {
            case 'Office':
              environmentMessage = this.context.isServedFromLocalhost ? strings.AppLocalEnvironmentOffice : strings.AppOfficeEnvironment;
              break;
            case 'Outlook':
              environmentMessage = this.context.isServedFromLocalhost ? strings.AppLocalEnvironmentOutlook : strings.AppOutlookEnvironment;
              break;
            case 'Teams':
            case 'TeamsModern':
              environmentMessage = this.context.isServedFromLocalhost ? strings.AppLocalEnvironmentTeams : strings.AppTeamsTabEnvironment;
              break;
            default:
              environmentMessage = strings.UnknownEnvironment;
          }

          return environmentMessage;
        });
    }

    return Promise.resolve(this.context.isServedFromLocalhost ? strings.AppLocalEnvironmentSharePoint : strings.AppSharePointEnvironment);
  }

  protected onThemeChanged(currentTheme: IReadonlyTheme | undefined): void {
    if (!currentTheme) {
      return;
    }

    const {
      semanticColors
    } = currentTheme;

    if (semanticColors) {
      this.domElement.style.setProperty('--bodyText', semanticColors.bodyText || null);
      this.domElement.style.setProperty('--link', semanticColors.link || null);
      this.domElement.style.setProperty('--linkHovered', semanticColors.linkHovered || null);
    }
  }

  protected get dataVersion(): Version {
    return Version.parse('1.0');
  }

  protected getPropertyPaneConfiguration(): IPropertyPaneConfiguration {
    return {
      pages: [
        {
          header: {
            description: strings.PropertyPaneDescription
          },
          groups: [
            {
              groupName: strings.BasicGroupName,
              groupFields: [
                PropertyPaneTextField('description', {
                  label: strings.DescriptionFieldLabel
                })
              ]
            }
          ]
        }
      ]
    };
  }
}
