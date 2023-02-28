*** Settings ***
Resource          ../../addons_robot/robot_utils/keywords/odoo_ee.robot

***Keywords***
Wait To Click   [Arguments]       ${xpath}
    Wait Until Element Is Visible          xpath=${xpath}
    Click Element                          xpath=${xpath}
    
Open Roundcube
    Go To                               ${ODOO_URL}/mailer
    Wait Until Page Contains Element    jquery:ul#mailboxlist    timeout=10s
    Capture Page Screenshot

Set Up Fetchserver     [Arguments]      ${subject}     ${record}
    Go to             ${ODOO_URL}/web?debug=1
    Log to Console    Set up fetchmail server with ${record}
    Wait To Click     xpath=//div[@class[contains(., 'o-dropdown dropdown o-dropdown--no-caret o_navbar_apps_menu')]]
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

Reply to Mail   [Arguments]      ${subject}         ${body}
    Go to             ${ODOO_URL}/mailer
    Log to Console    Replying to email
    Wait To Click     xpath=(//span[text()='Mail'])[1]
    Wait To Click     xpath=(//span[text()='${subject}'])[1]
    Capture Page Screenshot
    Wait To Click     xpath=(//span[text()='Reply'])[1]
    Wait Until Element Is Visible   xpath=//button[text()='Send']
    Input Text        xpath=//textarea[@name='_message']     ${body}
    Capture Page Screenshot
    Click Element     xpath=//button[text()='Send']

Create Identity  [Arguments]      ${name}      ${email}
    Go to             ${ODOO_URL}/mailer/index.php?_task=settings
    Log to Console    Creating contact
    Capture Page Screenshot
    Wait To Click     xpath=(//li[@id='settingstabidentities'])[1]
    Capture Page Screenshot
    Wait To Click     xpath=//ul[@class="menu toolbar listing iconized"]/li/a[@title="Create new identity"]
    Capture Page Screenshot
    Input Text                       jquery:input[name='_name']       ${name}
    Input Text                       jquery:input[name='_email']       ${name}
    Capture Page Screenshot
    Click Element                    jquery:button.submit
    Capture Page Screenshot

Delete All Mails
    Go to             ${ODOO_URL}/mailer
    Log to Console    Deleting all emails
    Wait To Click     xpath=(//span[text()='Mail'])[1]
    Wait To Click     xpath=//a[@title='Folder actions...' and @class='button icon sidebar-menu active' and @data-popup='mailboxoptions-menu' and @id='rcmbtn107' and @role='button' and @href='#' and @aria-haspopup='true' and @aria-expanded='false' and @aria-owns='mailboxoptions-menu' and @data-original-title='Folder actions...']
    Capture Page Screenshot
    Wait To Click     xpath=//a[text()='Empty']
    Capture Page Screenshot
    Wait To Click     xpath=//button[@type='button' and @class='mainaction delete btn btn-primary btn-danger' and text()='Delete']
    Capture Page Screenshot
    Log to Console    All emails deleted.

Send Mail
    [Arguments]                      ${recipient}       ${subject}       ${body}
    Open Roundcube
    Click Element                    jquery:a.compose
    Wait Until Element Is Visible    jquery:ul.recipient-input           timeout=3 sec
    Input Text                       jquery:ul.recipient-input input     ${recipient}
    Input Text                       jquery:input[name='_subject']       ${subject}
    Input Text                       jquery:textarea[name='_message']    ${body}
    Click Element                    jquery:button.send
    
