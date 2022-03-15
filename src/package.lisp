(defpackage #:cl-forms
  (:nicknames :forms)
  (:use #:cl)
  (:export
   :form
   :form-field
   :with-form
   :with-form-renderer
   :with-form-theme
   :defform
   :defform-builder
   :find-form
   :find-form
   :get-field
   :get-field-value
   :set-field-value
   :render-form
   :render-form-start
   :render-form-end
   :render-field
   :render-field-label
   :render-field-errors
   :render-field-widget
   :render-form-errors
   :fill-form-from-model
   :fill-model-from-form
   :with-form-fields
   :with-form-field-values
   :field-value
   :field-valid-p
   :field-formatter
   :field-parser
   :field-accessor
   :field-writer
   :field-reader
   :add-field
   :remove-field
   :handle-request
   :validate-form
   :form-valid-p
   :form-errors
   :add-form-error
   :with-form-template
   :format-field-value
   :format-field-value-to-string
   :make-formatter
   :*base64-encode*
   ;; Fields
   :choice-form-field
   :string-form-field
   :text-form-field
   :boolean-form-field
   :file-form-field
   :hidden-form-field
   :list-form-field
   :password-form-field
   :subform-form-field
   :submit-form-field
   :email-form-field
   :datetime-form-field
   :date-form-field
   :integer-form-field
   :url-form-field
   ))
