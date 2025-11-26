---
title: TextField
description: >-
  Lets users enter or edit text within a single-line input. Use to collect
  short, free-form information from users.
api_name: app-home
source_url:
  html: 'https://shopify.dev/docs/api/app-home/polaris-web-components/forms/textfield'
  md: >-
    https://shopify.dev/docs/api/app-home/polaris-web-components/forms/textfield.md
---

# TextField

Lets users enter or edit text within a single-line input. Use to collect short, free-form information from users.

## TextField

A text input field that allows users to enter and edit text.

* autocomplete

  "on" | "off" | TextAutocompleteField | \`section-${string} one-time-code\` | "shipping one-time-code" | "billing one-time-code" | \`section-${string} shipping one-time-code\` | \`section-${string} billing one-time-code\` | \`section-${string} language\` | \`section-${string} organization\` | \`section-${string} additional-name\` | \`section-${string} address-level1\` | \`section-${string} address-level2\` | \`section-${string} address-level3\` | \`section-${string} address-level4\` | \`section-${string} address-line1\` | \`section-${string} address-line2\` | \`section-${string} address-line3\` | \`section-${string} country-name\` | \`section-${string} country\` | \`section-${string} family-name\` | \`section-${string} given-name\` | \`section-${string} honorific-prefix\` | \`section-${string} honorific-suffix\` | \`section-${string} name\` | \`section-${string} nickname\` | \`section-${string} organization-title\` | \`section-${string} postal-code\` | \`section-${string} sex\` | \`section-${string} street-address\` | \`section-${string} transaction-currency\` | \`section-${string} username\` | \`section-${string} cc-additional-name\` | \`section-${string} cc-family-name\` | \`section-${string} cc-given-name\` | \`section-${string} cc-name\` | \`section-${string} cc-type\` | "shipping language" | "shipping organization" | "shipping additional-name" | "shipping address-level1" | "shipping address-level2" | "shipping address-level3" | "shipping address-level4" | "shipping address-line1" | "shipping address-line2" | "shipping address-line3" | "shipping country-name" | "shipping country" | "shipping family-name" | "shipping given-name" | "shipping honorific-prefix" | "shipping honorific-suffix" | "shipping name" | "shipping nickname" | "shipping organization-title" | "shipping postal-code" | "shipping sex" | "shipping street-address" | "shipping transaction-currency" | "shipping username" | "shipping cc-additional-name" | "shipping cc-family-name" | "shipping cc-given-name" | "shipping cc-name" | "shipping cc-type" | "billing language" | "billing organization" | "billing additional-name" | "billing address-level1" | "billing address-level2" | "billing address-level3" | "billing address-level4" | "billing address-line1" | "billing address-line2" | "billing address-line3" | "billing country-name" | "billing country" | "billing family-name" | "billing given-name" | "billing honorific-prefix" | "billing honorific-suffix" | "billing name" | "billing nickname" | "billing organization-title" | "billing postal-code" | "billing sex" | "billing street-address" | "billing transaction-currency" | "billing username" | "billing cc-additional-name" | "billing cc-family-name" | "billing cc-given-name" | "billing cc-name" | "billing cc-type" | \`section-${string} shipping language\` | \`section-${string} shipping organization\` | \`section-${string} shipping additional-name\` | \`section-${string} shipping address-level1\` | \`section-${string} shipping address-level2\` | \`section-${string} shipping address-level3\` | \`section-${string} shipping address-level4\` | \`section-${string} shipping address-line1\` | \`section-${string} shipping address-line2\` | \`section-${string} shipping address-line3\` | \`section-${string} shipping country-name\` | \`section-${string} shipping country\` | \`section-${string} shipping family-name\` | \`section-${string} shipping given-name\` | \`section-${string} shipping honorific-prefix\` | \`section-${string} shipping honorific-suffix\` | \`section-${string} shipping name\` | \`section-${string} shipping nickname\` | \`section-${string} shipping organization-title\` | \`section-${string} shipping postal-code\` | \`section-${string} shipping sex\` | \`section-${string} shipping street-address\` | \`section-${string} shipping transaction-currency\` | \`section-${string} shipping username\` | \`section-${string} shipping cc-additional-name\` | \`section-${string} shipping cc-family-name\` | \`section-${string} shipping cc-given-name\` | \`section-${string} shipping cc-name\` | \`section-${string} shipping cc-type\` | \`section-${string} billing language\` | \`section-${string} billing organization\` | \`section-${string} billing additional-name\` | \`section-${string} billing address-level1\` | \`section-${string} billing address-level2\` | \`section-${string} billing address-level3\` | \`section-${string} billing address-level4\` | \`section-${string} billing address-line1\` | \`section-${string} billing address-line2\` | \`section-${string} billing address-line3\` | \`section-${string} billing country-name\` | \`section-${string} billing country\` | \`section-${string} billing family-name\` | \`section-${string} billing given-name\` | \`section-${string} billing honorific-prefix\` | \`section-${string} billing honorific-suffix\` | \`section-${string} billing name\` | \`section-${string} billing nickname\` | \`section-${string} billing organization-title\` | \`section-${string} billing postal-code\` | \`section-${string} billing sex\` | \`section-${string} billing street-address\` | \`section-${string} billing transaction-currency\` | \`section-${string} billing username\` | \`section-${string} billing cc-additional-name\` | \`section-${string} billing cc-family-name\` | \`section-${string} billing cc-given-name\` | \`section-${string} billing cc-name\` | \`section-${string} billing cc-type\`

  Default: 'on' for everything else

  A hint as to the intended content of the field.

  When set to `on` (the default), this property indicates that the field should support autofill, but you do not have any more semantic information on the intended contents.

  When set to `off`, you are indicating that this field contains sensitive information, or contents that are never saved, like one-time codes.

  Alternatively, you can provide value which describes the specific data you would like to be entered into this field during autofill.

* defaultValue

  string

  The default value for the field.

* details

  string

  Additional text to provide context or guidance for the field. This text is displayed along with the field and its label to offer more information or instructions to the user.

  This will also be exposed to screen reader users.

* disabled

  boolean

  Default: false

  Disables the field, disallowing any interaction.

* error

  string

  Indicate an error to the user. The field will be given a specific stylistic treatment to communicate problems that have to be resolved immediately.

* icon

  "replace" | "search" | "split" | "link" | "edit" | "product" | "variant" | "collection" | "select" | "info" | "incomplete" | "complete" | "color" | "money" | "adjust" | "affiliate" | "airplane" | "alert-bubble" | "alert-circle" | "alert-diamond" | "alert-location" | "alert-octagon" | "alert-octagon-filled" | "alert-triangle" | "alert-triangle-filled" | "app-extension" | "apps" | "archive" | "arrow-down" | "arrow-down-circle" | "arrow-down-right" | "arrow-left" | "arrow-left-circle" | "arrow-right" | "arrow-right-circle" | "arrow-up" | "arrow-up-circle" | "arrow-up-right" | "arrows-in-horizontal" | "arrows-out-horizontal" | "asterisk" | "attachment" | "automation" | "backspace" | "bag" | "bank" | "barcode" | "battery-low" | "bill" | "blank" | "blog" | "bolt" | "bolt-filled" | "book" | "book-open" | "bug" | "bullet" | "business-entity" | "button" | "button-press" | "calculator" | "calendar" | "calendar-check" | "calendar-compare" | "calendar-list" | "calendar-time" | "camera" | "camera-flip" | "caret-down" | "caret-left" | "caret-right" | "caret-up" | "cart" | "cart-abandoned" | "cart-discount" | "cart-down" | "cart-filled" | "cart-sale" | "cart-send" | "cart-up" | "cash-dollar" | "cash-euro" | "cash-pound" | "cash-rupee" | "cash-yen" | "catalog-product" | "categories" | "channels" | "chart-cohort" | "chart-donut" | "chart-funnel" | "chart-histogram-first" | "chart-histogram-first-last" | "chart-histogram-flat" | "chart-histogram-full" | "chart-histogram-growth" | "chart-histogram-last" | "chart-histogram-second-last" | "chart-horizontal" | "chart-line" | "chart-popular" | "chart-stacked" | "chart-vertical" | "chat" | "chat-new" | "chat-referral" | "check" | "check-circle" | "check-circle-filled" | "checkbox" | "chevron-down" | "chevron-down-circle" | "chevron-left" | "chevron-left-circle" | "chevron-right" | "chevron-right-circle" | "chevron-up" | "chevron-up-circle" | "circle" | "circle-dashed" | "clipboard" | "clipboard-check" | "clipboard-checklist" | "clock" | "clock-list" | "clock-revert" | "code" | "code-add" | "collection-featured" | "collection-list" | "collection-reference" | "color-none" | "compass" | "compose" | "confetti" | "connect" | "content" | "contract" | "corner-pill" | "corner-round" | "corner-square" | "credit-card" | "credit-card-cancel" | "credit-card-percent" | "credit-card-reader" | "credit-card-reader-chip" | "credit-card-reader-tap" | "credit-card-secure" | "credit-card-tap-chip" | "crop" | "currency-convert" | "cursor" | "cursor-banner" | "cursor-option" | "data-presentation" | "data-table" | "database" | "database-add" | "database-connect" | "delete" | "delivered" | "delivery" | "desktop" | "disabled" | "disabled-filled" | "discount" | "discount-add" | "discount-automatic" | "discount-code" | "discount-remove" | "dns-settings" | "dock-floating" | "dock-side" | "domain" | "domain-landing-page" | "domain-new" | "domain-redirect" | "download" | "drag-drop" | "drag-handle" | "drawer" | "duplicate" | "email" | "email-follow-up" | "email-newsletter" | "empty" | "enabled" | "enter" | "envelope" | "envelope-soft-pack" | "eraser" | "exchange" | "exit" | "export" | "external" | "eye-check-mark" | "eye-dropper" | "eye-dropper-list" | "eye-first" | "eyeglasses" | "fav" | "favicon" | "file" | "file-list" | "filter" | "filter-active" | "flag" | "flip-horizontal" | "flip-vertical" | "flower" | "folder" | "folder-add" | "folder-down" | "folder-remove" | "folder-up" | "food" | "foreground" | "forklift" | "forms" | "games" | "gauge" | "geolocation" | "gift" | "gift-card" | "git-branch" | "git-commit" | "git-repository" | "globe" | "globe-asia" | "globe-europe" | "globe-lines" | "globe-list" | "graduation-hat" | "grid" | "hashtag" | "hashtag-decimal" | "hashtag-list" | "heart" | "hide" | "hide-filled" | "home" | "home-filled" | "icons" | "identity-card" | "image" | "image-add" | "image-alt" | "image-explore" | "image-magic" | "image-none" | "image-with-text-overlay" | "images" | "import" | "in-progress" | "incentive" | "incoming" | "info-filled" | "inheritance" | "inventory" | "inventory-edit" | "inventory-list" | "inventory-transfer" | "inventory-updated" | "iq" | "key" | "keyboard" | "keyboard-filled" | "keyboard-hide" | "keypad" | "label-printer" | "language" | "language-translate" | "layout-block" | "layout-buy-button" | "layout-buy-button-horizontal" | "layout-buy-button-vertical" | "layout-column-1" | "layout-columns-2" | "layout-columns-3" | "layout-footer" | "layout-header" | "layout-logo-block" | "layout-popup" | "layout-rows-2" | "layout-section" | "layout-sidebar-left" | "layout-sidebar-right" | "lightbulb" | "link-list" | "list-bulleted" | "list-bulleted-filled" | "list-numbered" | "live" | "live-critical" | "live-none" | "location" | "location-none" | "lock" | "map" | "markets" | "markets-euro" | "markets-rupee" | "markets-yen" | "maximize" | "measurement-size" | "measurement-size-list" | "measurement-volume" | "measurement-volume-list" | "measurement-weight" | "measurement-weight-list" | "media-receiver" | "megaphone" | "mention" | "menu" | "menu-filled" | "menu-horizontal" | "menu-vertical" | "merge" | "metafields" | "metaobject" | "metaobject-list" | "metaobject-reference" | "microphone" | "microphone-muted" | "minimize" | "minus" | "minus-circle" | "mobile" | "money-none" | "money-split" | "moon" | "nature" | "note" | "note-add" | "notification" | "number-one" | "order" | "order-batches" | "order-draft" | "order-filled" | "order-first" | "order-fulfilled" | "order-repeat" | "order-unfulfilled" | "orders-status" | "organization" | "outdent" | "outgoing" | "package" | "package-cancel" | "package-fulfilled" | "package-on-hold" | "package-reassign" | "package-returned" | "page" | "page-add" | "page-attachment" | "page-clock" | "page-down" | "page-heart" | "page-list" | "page-reference" | "page-remove" | "page-report" | "page-up" | "pagination-end" | "pagination-start" | "paint-brush-flat" | "paint-brush-round" | "paper-check" | "partially-complete" | "passkey" | "paste" | "pause-circle" | "payment" | "payment-capture" | "payout" | "payout-dollar" | "payout-euro" | "payout-pound" | "payout-rupee" | "payout-yen" | "person" | "person-add" | "person-exit" | "person-filled" | "person-list" | "person-lock" | "person-remove" | "person-segment" | "personalized-text" | "phablet" | "phone" | "phone-down" | "phone-down-filled" | "phone-in" | "phone-out" | "pin" | "pin-remove" | "plan" | "play" | "play-circle" | "plus" | "plus-circle" | "plus-circle-down" | "plus-circle-filled" | "plus-circle-up" | "point-of-sale" | "point-of-sale-register" | "price-list" | "print" | "product-add" | "product-cost" | "product-filled" | "product-list" | "product-reference" | "product-remove" | "product-return" | "product-unavailable" | "profile" | "profile-filled" | "question-circle" | "question-circle-filled" | "radio-control" | "receipt" | "receipt-dollar" | "receipt-euro" | "receipt-folded" | "receipt-paid" | "receipt-pound" | "receipt-refund" | "receipt-rupee" | "receipt-yen" | "receivables" | "redo" | "referral-code" | "refresh" | "remove-background" | "reorder" | "replay" | "reset" | "return" | "reward" | "rocket" | "rotate-left" | "rotate-right" | "sandbox" | "save" | "savings" | "scan-qr-code" | "search-add" | "search-list" | "search-recent" | "search-resource" | "send" | "settings" | "share" | "shield-check-mark" | "shield-none" | "shield-pending" | "shield-person" | "shipping-label" | "shipping-label-cancel" | "shopcodes" | "slideshow" | "smiley-happy" | "smiley-joy" | "smiley-neutral" | "smiley-sad" | "social-ad" | "social-post" | "sort" | "sort-ascending" | "sort-descending" | "sound" | "sports" | "star" | "star-circle" | "star-filled" | "star-half" | "star-list" | "status" | "status-active" | "stop-circle" | "store" | "store-import" | "store-managed" | "store-online" | "sun" | "table" | "table-masonry" | "tablet" | "target" | "tax" | "team" | "text" | "text-align-center" | "text-align-left" | "text-align-right" | "text-block" | "text-bold" | "text-color" | "text-font" | "text-font-list" | "text-grammar" | "text-in-columns" | "text-in-rows" | "text-indent" | "text-indent-remove" | "text-italic" | "text-quote" | "text-title" | "text-underline" | "text-with-image" | "theme" | "theme-edit" | "theme-store" | "theme-template" | "three-d-environment" | "thumbs-down" | "thumbs-up" | "tip-jar" | "toggle-off" | "toggle-on" | "transaction" | "transaction-fee-add" | "transaction-fee-dollar" | "transaction-fee-euro" | "transaction-fee-pound" | "transaction-fee-rupee" | "transaction-fee-yen" | "transfer" | "transfer-in" | "transfer-internal" | "transfer-out" | "truck" | "undo" | "unknown-device" | "unlock" | "upload" | "variant-list" | "video" | "video-list" | "view" | "viewport-narrow" | "viewport-short" | "viewport-tall" | "viewport-wide" | "wallet" | "wand" | "watch" | "wifi" | "work" | "work-list" | "wrench" | "x" | "x-circle" | "x-circle-filled" | AnyString

  Default: ''

  The type of icon to be displayed in the field.

* id

  string

  A unique identifier for the element.

* label

  string

  Content to use as the field label.

* labelAccessibilityVisibility

  "visible" | "exclusive"

  Default: 'visible'

  Changes the visibility of the component's label.

    * `visible`: the label is visible to all users.
    * `exclusive`: the label is visually hidden but remains in the accessibility tree.

* maxLength

  number

  Default: Infinity

  Specifies the maximum number of characters allowed.

* minLength

  number

  Default: 0

  Specifies the min number of characters allowed.

* name

  string

  An identifier for the field that is unique within the nearest containing form.

* placeholder

  string

  A short hint that describes the expected value of the field.

* prefix

  string

  Default: ''

  A value to be displayed immediately before the editable portion of the field.

  This is useful for displaying an implied part of the value, such as "https://" or "+353".

  This cannot be edited by the user, and it isn't included in the value of the field.

  It may not be displayed until the user has interacted with the input. For example, an inline label may take the place of the prefix until the user focuses the input.

* readOnly

  boolean

  Default: false

  The field cannot be edited by the user. It is focusable will be announced by screen readers.

* required

  boolean

  Default: false

  Whether the field needs a value. This requirement adds semantic value to the field, but it will not cause an error to appear automatically. If you want to present an error when this field is empty, you can do so with the `error` property.

* suffix

  string

  Default: ''

  A value to be displayed immediately after the editable portion of the field.

  This is useful for displaying an implied part of the value, such as "@shopify.com", or "%".

  This cannot be edited by the user, and it isn't included in the value of the field.

  It may not be displayed until the user has interacted with the input. For example, an inline label may take the place of the suffix until the user focuses the input.

* value

  string

  The current value for the field. If omitted, the field will be empty.

### TextAutocompleteField

```ts
'language' | 'organization' | 'additional-name' | 'address-level1' | 'address-level2' | 'address-level3' | 'address-level4' | 'address-line1' | 'address-line2' | 'address-line3' | 'country-name' | 'country' | 'family-name' | 'given-name' | 'honorific-prefix' | 'honorific-suffix' | 'name' | 'nickname' | 'one-time-code' | 'organization-title' | 'postal-code' | 'sex' | 'street-address' | 'transaction-currency' | 'username' | 'cc-additional-name' | 'cc-family-name' | 'cc-given-name' | 'cc-name' | 'cc-type'
```

### AnyString

Prevents widening string literal types in a union to \`string\`.

```ts
string & {}
```

## Slots

* accessory

  HTMLElement

  The accessory to display in the text field.

## Events

Learn more about [registering events](https://shopify.dev/docs/api/app-home/using-polaris-components#event-handling).

* blur

  CallbackEventListener<'input'>

* change

  CallbackEventListener<'input'>

* focus

  CallbackEventListener<'input'>

* input

  CallbackEventListener<'input'>

### CallbackEventListener

```ts
(EventListener & {
(event: CallbackEvent<T>): void;
}) | null
```

### CallbackEvent

```ts
Event & {
    currentTarget: HTMLElementTagNameMap[T];
}
```

### Examples

* #### Code

  ##### jsx

  ```jsx
  <s-text-field
    label="Store name"
    value="Jaded Pixel"
    placeholder="Become a merchant"
   />
  ```

  ##### html

  ```html
  <s-text-field
    label="Store name"
    value="Jaded Pixel"
    placeholder="Become a merchant"
  ></s-text-field>
  ```

## Examples

Component examples

### Basic usage

### Examples

* #### Basic usage

  ##### Description

  Demonstrates a simple text input field for entering a store name with autocomplete turned off, providing a clean and straightforward input experience.

  ##### jsx

  ```jsx
  <s-text-field label="Store name" autocomplete="off" />
  ```

  ##### html

  ```html
  <s-text-field label="Store name" autocomplete="off"></s-text-field>
  ```

* #### With icon

  ##### Description

  Showcases a text field enhanced with a search icon and a placeholder, creating a visually intuitive input for searching products.

  ##### jsx

  ```jsx
  <s-text-field
    label="Search"
    icon="search"
    placeholder="Search products..."
   />
  ```

  ##### html

  ```html
  <s-text-field
    label="Search"
    icon="search"
    placeholder="Search products..."
  ></s-text-field>
  ```

* #### Specific error messages for merchant context

  ##### Description

  Demonstrates the importance of providing clear, actionable, and context-specific error messages that guide merchants toward correct input and understanding.

  ##### jsx

  ```jsx
  <s-stack gap="base">
    {/* Generic error (avoid) */}
    <s-text-field label="Product weight" error="Invalid value" />

    {/* Specific error (preferred) */}
    <s-text-field
      label="Product weight"
      error="Weight must be greater than 0 and less than 500 pounds for shipping calculations"
     />

    {/* Business rule error */}
    <s-text-field
      label="SKU"
      error="SKU 'TSHIRT-001' already exists. SKUs must be unique across all products."
     />
  </s-stack>
  ```

  ##### html

  ```html
  <s-stack gap="base">
    <!-- Generic error (avoid) -->
    <s-text-field label="Product weight" error="Invalid value"></s-text-field>

    <!-- Specific error (preferred) -->
    <s-text-field
      label="Product weight"
      error="Weight must be greater than 0 and less than 500 pounds for shipping calculations"
    ></s-text-field>

    <!-- Business rule error -->
    <s-text-field
      label="SKU"
      error="SKU 'TSHIRT-001' already exists. SKUs must be unique across all products."
    ></s-text-field>
  </s-stack>
  ```

* #### Required field with validation

  ##### Description

  Illustrates a text field marked as required, ensuring that users must provide input before form submission, with built-in validation support.

  ##### jsx

  ```jsx
  <s-text-field label="Store name" required />
  ```

  ##### html

  ```html
  <s-text-field label="Store name" required></s-text-field>
  ```

* #### With prefix and suffix

  ##### Description

  Displays text field usage with prefix and suffix

  ##### jsx

  ```jsx
  <s-stack gap="small">
      <s-text-field
      label="Phone number"
      prefix="+03"
      />
      <s-text-field
      label="Credit Card Number"
      value="1234 5678 9012 3456"
      suffix="VISA"
      />
  </s-stack>
  ```

  ##### html

  ```html
  <s-stack gap="small">
    <s-text-field label="Phone number" prefix="+03" />
    <s-text-field
      label="Credit Card Number"
      value="1234 5678 9012 3456"
      suffix="VISA"
    />
  </s-stack>
  ```

* #### With accessory

  ##### Description

  Demonstrates the flexibility of adding interactive elements like buttons to text fields, enabling immediate actions based on the entered input.

  ##### jsx

  ```jsx
  <>
    <s-tooltip id="info-tooltip">This is info tooltip</s-tooltip>
    <s-text-field label="Discount code">
      <s-icon slot="accessory" interestFor="info-tooltip" type="info" />
    </s-text-field>
  </>
  ```

  ##### html

  ```html
  <s-tooltip id="info-tooltip">This is info tooltip</s-tooltip>
  <s-text-field label="Discount code">
    <s-icon slot="accessory" interestFor="info-tooltip" type="info" />
  </s-text-field>
  ```