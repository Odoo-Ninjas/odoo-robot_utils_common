
*** Settings ***

Documentation    Roundcube Mail Client
Library          SeleniumLibrary
Library          ../library/tools.py

# Samples
#    Roundcube Send Mail    marc.wimmer@gmx.de    subject    body

*** Keywords ***

Open Roundcube
    Go To                               ${ODOO_URL}/mailer
    Wait Until Page Contains Element    jquery:ul#mailboxlist    timeout=10s
    Capture Page Screenshot

Roundcube Subject Should be visible
    [Arguments]                         ${subject}
    Go To                               ${ODOO_URL}/mailer
    Wait Until Page Contains Element    xpath://span[@class='subject']//span[contains(text(), '${subject}')]    timeout=4s

Roundcube Send Mail
    [Arguments]                      ${recipient}                        ${subject}       ${body}
    Open Roundcube
    Click Element                    jquery:a.compose
    Wait Until Element Is Visible    jquery:ul.recipient-input           timeout=3 sec
    Input Text                       jquery:ul.recipient-input input     ${recipient}
    Input Text                       jquery:input[name='_subject']       ${subject}
    Input Text                       jquery:textarea[name='_message']    ${body}
    Click Element                    jquery:button.send

Roundcube Clear All
    [Documentation]                  Erases all emails;
    Open Roundcube
    FOR                              ${i}                                         IN RANGE                     999999
    Run Keyword and Return Status    jquery:table#messagelist>tbody>tr:visible    timeout=5 sec
    ${present}=                      Run Keyword and Return Status                Element Should be Visible    jquery:table#messagelist>tbody>tr:visible
    Exit For Loop If                 not ${present}

    Run Keyword Unless                          ${i} > 1                          Click Element    jquery:table#messagelist>tbody>tr:visible
    Wait Until Page does NOT Contain Element    jquery:#messagestack div
    Wait Until Page Contains Element            jquery:a.delete:not(disabled)
    Click Element                               jquery:a.delete:not(disabled)
    Wait Until Page does NOT Contain Element    jquery:#messagestack div
    Log                                         Deleting a mail from roundcube
    Capture Page Screenshot
    END

Wait To Click
    [Arguments]                      ${xpath}
    Wait Until Element Is Visible    xpath=${xpath}
    Click Element                    xpath=${xpath}

Set Up Fetchserver
    [Arguments]                      ${subject}
    Go to                            ${ODOO_URL}/web?debug=1
    Log to Console                   Set up fetchmail server with Helpdesk
    # Wait To Click     xpath=//a[@class[contains(., 'full')]]
    # Capture Page Screenshot
    # Click Menu        menu=base.menu_administration
    Go to                            ${ODOO_URL}/web#menu_id=4
    Capture Page Screenshot
    Click Menu                       menu=base.menu_custom
    Click Menu                       menu=fetchmail.menu_action_fetchmail_server_tree
    Capture Page Screenshot
    Wait To Click                    xpath=//td[@title="${subject}"]
    Capture Page Screenshot
    Button                           class=btn btn-primary o_form_button_edit
    Wait Until Element Is Visible    xpath=//button[@class="btn btn-primary o_form_button_save"]
    Many2OneSelect                   model=fetchmail.server                                         field=object_id    value=Helpdesk Ticket
    Button                           class=btn btn-primary o_form_button_save

Fetch Mail
    [Arguments]                ${subject}
    Go to                      ${ODOO_URL}/web?debug=1
    Log to Console             Fetching Mail
    Go to                      ${ODOO_URL}/web#menu_id=4
    Capture Page Screenshot
    Click Menu                 menu=base.menu_custom
    Click Menu                 menu=fetchmail.menu_action_fetchmail_server_tree
    Capture Page Screenshot
    Wait To Click              xpath=//td[@title="${subject}"]
    Capture Page Screenshot
    Button                     name=fetch_mail

Send A Mail
    [Arguments]                ${subject}                                            ${name}                 ${email}
    Go to                      ${ODOO_URL}/mailer
    Log to Console             Sending a mail
    Wait To Click              xpath=(//span[text()='Compose'])[1]
    Capture Page Screenshot
    Wait To Click              xpath=//select[@id="_from"]
    Wait To Click              xpath=//div/ul/li/a[text()="Robo <robo@bobo.com>"]
    Input Text                 xpath=//input[@role='combobox']                       ${name} <${email}>
    Input Text                 xpath=//input[@name='_subject']                       ${subject}
    Input Text                 xpath=//textarea[@name='_message']                    Does this test work?
    Capture Page Screenshot
    Wait To Click              xpath=//button[text()='Send']

Reply to Mail
    [Arguments]                      ${subject}
    Log to Console                   Replying to email
    Wait To Click                    xpath=(//span[text()='Mail'])[1]
    Wait To Click                    xpath=(//span[text()='${subject}'])[1]
    Capture Page Screenshot
    Wait To Click                    xpath=(//span[text()='Reply'])[1]
    Wait Until Element Is Visible    xpath=//button[text()='Send']
    Input Text                       xpath=//textarea[@name='_message']        Hopefully it is working!
    Capture Page Screenshot
    Click Element                    xpath=//button[text()='Send']

Create Identity
    [Arguments]                ${name}                                                                                  ${email}
    Go to                      ${ODOO_URL}/mailer/index.php?_task=settings
    Log to Console             Creating contact
    Capture Page Screenshot
    Wait To Click              xpath=(//li[@id='settingstabidentities'])[1]
    Capture Page Screenshot
    Wait To Click              xpath=//ul[@class="menu toolbar listing iconized"]/li/a[@title="Create new identity"]
    Capture Page Screenshot
    Input Text                 xpath=//td/input[@id="rcmfd_name"]                                                       ${name} 
    Input Text                 xpath=//td/input[@id="rcmfd_email"]                                                      ${email}
    Capture Page Screenshot
    Wait To Click              xpath=//div/button[@class="btn btn-primary submit"]




