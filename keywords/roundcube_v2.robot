*** Settings ***
Resource          ../../addons_robot/robot_utils/keywords/odoo_ee.robot


***Keywords***
Open Roundcube
    Go To                               ${ODOO_URL}/mailer
    Wait Until Page Contains Element    jquery:ul#mailboxlist    timeout=10s
    Capture Page Screenshot
    
Set Up Fetchserver     [Arguments]      ${subject}     ${record}
    Go to             ${ODOO_URL}/web?debug=1
    Log to Console    Set up fetchmail server with ${record}
    Wait To Click     xpath=//div[@class[contains(., 'o-dropdown dropdown o-dropdown--no-caret o_navbar_apps_menu')]]
    # Capture Page Screenshot
    Capture Page Screenshot
    Wait To Click     xpath=//a[@data-menu-xmlid='base.menu_administration']
    Capture Page Screenshot
    Wait To Click        xpath=//button[@data-menu-xmlid='base.menu_custom']
    Wait To Click        xpath=//a[@data-menu-xmlid='fetchmail.menu_action_fetchmail_server_tree']
    Capture Page Screenshot
    Wait To Click     xpath=//td[@title="${subject}"]
    Capture Page Screenshot
    Button            class=btn btn-primary o_form_button_edit
    Wait Until Element Is Visible   xpath=//button[@class="btn btn-primary o_form_button_save"]
    Many2OneSelect    model=fetchmail.server                 field=object_id             value=${record}
    Button            class=btn btn-primary o_form_button_save

Fetch Mail     [Arguments]      ${subject}
    Go to             ${ODOO_URL}/web?debug=1
    Wait To Click     xpath=//div[@class[contains(., 'o-dropdown dropdown o-dropdown--no-caret o_navbar_apps_menu')]]
    # Capture Page Screenshot
    Capture Page Screenshot
    Wait To Click     xpath=//a[@data-menu-xmlid='base.menu_administration']
    Capture Page Screenshot
    Wait To Click        xpath=//button[@data-menu-xmlid='base.menu_custom']
    Wait To Click        xpath=//a[@data-menu-xmlid='fetchmail.menu_action_fetchmail_server_tree']
    Capture Page Screenshot
    Wait To Click     xpath=//td[@title="${subject}"]
    Capture Page Screenshot
    Button            name=button_confirm_login
    Capture Page Screenshot
    Button            name=fetch_mail

Roundcube Subject Should be visible
    [Arguments]                         ${subject}
    Go To                               ${ODOO_URL}/mailer
    Wait Until Page Contains Element    xpath://span[@class='subject']//span[contains(text(), '${subject}')]    timeout=4s

Roundcube Send Mail.  [Arguments]                      ${recipient}                        ${subject}       ${body}
    Open Roundcube
    Click Element                    jquery:a.compose
    Wait Until Element Is Visible    jquery:ul.recipient-input           timeout=3 sec
    Input Text                       jquery:ul.recipient-input input     ${recipient}
    Input Text                       jquery:input[name='_subject']       ${subject}
    Input Text                       jquery:textarea[name='_message']    ${body}
    Click Element                    jquery:button.send

Roundcube Reply to Mail   [Arguments]      ${subject}         ${body}
    Log to Console    Replying to email
    Wait To Click     xpath=(//span[text()='Mail'])[1]
    Wait To Click     xpath=(//span[text()='${subject}'])[1]
    Capture Page Screenshot
    Wait To Click     xpath=(//span[text()='Reply'])[1]
    Wait Until Element Is Visible   xpath=//button[text()='Send']
    Input Text        xpath=//textarea[@name='_message']     ${body}
    Capture Page Screenshot
    Click Element     xpath=//button[text()='Send']

Roundcube Create Identity  [Arguments]      ${name}      ${email}
    Go to             ${ODOO_URL}/mailer/index.php?_task=settings
    Log to Console    Creating contact
    Capture Page Screenshot
    Wait To Click     xpath=(//li[@id='settingstabidentities'])[1]
    Capture Page Screenshot
    Wait To Click     xpath=//ul[@class="menu toolbar listing iconized"]/li/a[@title="Create new identity"]
    Capture Page Screenshot
    Input Text        xpath=//td/input[@id="rcmfd_name"]   ${name} 
    Input Text        xpath=//td/input[@id="rcmfd_email"]   ${email}
    Capture Page Screenshot
    Wait To Click     xpath=//div/button[@class="btn btn-primary submit"]
