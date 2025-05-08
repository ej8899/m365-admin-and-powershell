import { Version } from '@microsoft/sp-core-library';
import {
  IPropertyPaneConfiguration,
  PropertyPaneTextField
} from '@microsoft/sp-property-pane';
import { BaseClientSideWebPart } from '@microsoft/sp-webpart-base';
import * as zxcvbn from 'zxcvbn';

export interface IPasswordStrengthTesterWebPartProps {
  description: string;
}

export default class PasswordStrengthTesterWebPart extends BaseClientSideWebPart<IPasswordStrengthTesterWebPartProps> {

  public render(): void {
    this.domElement.innerHTML = `
      <div style="font-family:Segoe UI, sans-serif; max-width:500px;">
        <h3>Password Strength Tester</h3>
        <input type="password" id="passwordInput" placeholder="Enter your password" style="width:100%; padding:8px;" />
        <div id="strengthMeter" style="height:8px; background:#eee; margin:10px 0;"><div style="height:8px;"></div></div>
        <p id="feedback" style="color:#555;"></p>
        <p id="warnings" style="color:#aa0000;"></p>
        <p id="crackTime" style="font-style:italic;"></p>
      </div>
    `;


    const pwInput = this.domElement.querySelector('#passwordInput') as HTMLInputElement;
    const meter = this.domElement.querySelector('#strengthMeter div') as HTMLElement;
    const feedback = this.domElement.querySelector('#feedback') as HTMLElement;
    const warnings = this.domElement.querySelector('#warnings') as HTMLElement;
    const crackTime = this.domElement.querySelector('#crackTime') as HTMLElement;

    pwInput.addEventListener('input', () => {
      const result = zxcvbn(pwInput.value);
      const colors = ['red', 'orange', 'yellow', 'blue', 'green'];
      meter.style.width = `${(result.score + 1) * 20}%`;
      meter.style.backgroundColor = colors[result.score];

      feedback.textContent = result.feedback.suggestions.join(' ') || 'Your password looks good!';
      warnings.textContent = result.feedback.warning || '';
      crackTime.innerHTML = `
        Estimated crack time (online): ${result.crack_times_display.online_no_throttling_10_per_second}<br>
        Estimated crack time (offline): ${result.crack_times_display.offline_slow_hashing_1e4_per_second}
      `;
    });
  }

  protected get dataVersion(): Version {
    return Version.parse('1.0');
  }

  protected getPropertyPaneConfiguration(): IPropertyPaneConfiguration {
    return {
      pages: [
        {
          header: {
            description: "Settings"
          },
          groups: [
            {
              groupName: "Main",
              groupFields: [
                PropertyPaneTextField('description', {
                  label: "Description"
                })
              ]
            }
          ]
        }
      ]
    };
  }
}
