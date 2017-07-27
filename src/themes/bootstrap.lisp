(in-package :forms.who)

(defclass bootstrap-form-theme (forms::default-form-theme)
  ())

(defun merge-css-classes (cls1 cls2)
  )

(defun format-css-classes (classes)
  (format nil "~{~a~^ ~}" (mapcar (lambda (class)
                                    (string-downcase (string class)))
                                  (remove-if #'null classes))))

(defmethod forms::renderer-render-form ((renderer (eql :who))
                                        (theme bootstrap-form-theme)
                                        form &rest args)
  (with-html-output (*html*)
    (apply #'forms::renderer-render-form-errors renderer theme form args)
    (:form :id (forms::form-id form)
           :action (forms::form-action form)
           :method (symbol-name (forms::form-method form))
           :class (format-css-classes
                   (list
                    (getf args :class)
                    (and (getf args :inline)
                         "form-inline")
                    (and (getf args :horizontal)
                         "form-horizontal")))
           (when (forms::form-csrf-protection-p form)
             (let ((token (forms::set-form-session-csrf-token form)))
               (htm
                (:input :name (forms::form-csrf-field-name form)
                        :type "hidden" :value token))))
           (loop for field in (forms::form-fields form)
              do
                (forms::renderer-render-field renderer theme (cdr field) form)))))

(defmethod forms::renderer-render-form-start ((renderer (eql :who))
                                              (theme bootstrap-form-theme)
                                              form &rest args)
  "Start form rendering"
  (fmt:fmt *html* "<form id=\"" (forms::form-id form) "\""
           "action=\"" (forms::form-action form) "\""
           "method=\"" (forms::form-method form) "\""
           "class=\"" (format-css-classes
                       (list
                        (getf args :class)
                        (and (getf args :inline)
                             "form-inline")
                        (and (getf args :horizontal)
                             "form-horizontal"))) "\">")
  (when (forms::form-csrf-protection-p form)
    (let ((token (forms::set-form-session-csrf-token form)))
      (who:with-html-output (html *html*)
        (:input :name (forms::form-csrf-field-name form)
                :type "hidden"
                :value token)))))

(defmethod forms::renderer-render-field ((renderer (eql :who))
                                         (theme bootstrap-form-theme)
                                         field form &rest args)
  (with-html-output (*html*)
    (:form-group :class (when (not (forms:field-valid-p field form))
                          "has-error")
                 (apply #'forms::renderer-render-field-label renderer theme field form args)
                 (apply #'forms::renderer-render-field-widget renderer theme field form args)
                 (apply #'forms::renderer-render-field-errors renderer theme field form args))))

(defmethod forms::renderer-render-field-widget
    ((renderer (eql :who))
     (theme bootstrap-form-theme)
     (field forms::string-form-field)
     form &rest args)
  (format *html* "<input type=\"text\"")
  (format *html* " name=\"~A\"" (forms::render-field-request-name field form))
  (format *html* " class=\"~A\"" (format-css-classes (list (getf args :class)
                                                           "form-control")))
  (when (forms::field-placeholder field)
    (format *html* " placeholder=\"~A\"" (forms::field-placeholder field)))
  (renderer-render-field-attributes renderer theme field form)
  (when (forms::field-value field)
    (format *html* " value=\"~A\""
            (forms:format-field-value-to-string field)))
  (format *html* "></input>"))

(defmethod forms::renderer-render-field-widget
    ((renderer (eql :who))
     (theme bootstrap-form-theme)
     (field forms::email-form-field) form &rest args)
  (format *html* "<input type=\"email\"")
  (format *html* " name=\"~A\"" (forms::render-field-request-name field form))
  (format *html* " class=\"~A\"" (format-css-classes (list (getf args :class)
                                                           "form-control")))
  (when (forms::field-placeholder field)
    (format *html* " placeholder=\"~A\"" (forms::field-placeholder field)))
  (renderer-render-field-attributes renderer theme field form)
  (when (forms::field-value field)
    (format *html* " value=\"~A\""
            (forms:format-field-value-to-string field)))
  (format *html* "></input>"))

(defmethod forms::renderer-render-field-widget
    ((renderer (eql :who))
     (theme bootstrap-form-theme)
     (field forms::url-form-field) form &rest args)
  (format *html* "<input type=\"url\"")
  (format *html* " name=\"~A\"" (forms::render-field-request-name field form))
  (format *html* " class=\"~A\"" (format-css-classes (list (getf args :class)
                                                           "form-control")))
  (when (forms::field-placeholder field)
    (format *html* " placeholder=\"~A\"" (forms::field-placeholder field)))
  (renderer-render-field-attributes renderer theme field form)
  (when (forms::field-value field)
    (format *html* " value=\"~A\""
            (forms:format-field-value-to-string field)))
  (format *html* "></input>"))

(defmethod forms::renderer-render-field-widget
    ((renderer (eql :who))
     (theme bootstrap-form-theme)
     (field forms::integer-form-field) form &rest args)
  (format *html* "<input type=\"number\"")
  (format *html* " name=\"~A\"" (forms::render-field-request-name field form))
  (format *html* " class=\"~A\"" (format-css-classes (list (getf args :class)
                                                           "form-control")))
  (when (forms::field-placeholder field)
    (format *html* " placeholder=\"~A\"" (forms::field-placeholder field)))
  (renderer-render-field-attributes renderer theme field form)
  (when (forms::field-value field)
    (format *html* " value=\"~A\""
            (forms:format-field-value-to-string field)))
  (format *html* "></input>"))

(defmethod forms::renderer-render-field-widget
    ((renderer (eql :who))
     (theme bootstrap-form-theme)
     (field forms::password-form-field)
     form &rest args)
  (format *html* "<input type=\"password\"")
  (format *html* " name=\"~A\"" (forms::render-field-request-name field form))
  (format *html* " class=\"~A\"" (format-css-classes (list (getf args :class)
                                                           "form-control")))
  (when (forms::field-placeholder field)
    (format *html* " placeholder=\"~A\"" (forms::field-placeholder field)))
  (renderer-render-field-attributes renderer theme field form)
  (when (forms::field-value field)
    (format *html* " value=\"~A\""
            (forms:format-field-value-to-string field)))
  (format *html* "></input>"))

(defmethod forms::renderer-render-field-widget
    ((renderer (eql :who))
     (theme bootstrap-form-theme)
     (field forms::submit-form-field) form &rest args)
  (with-html-output (*html*)
    (:button :type "submit"
             :class "btn btn-default"
             (who:str (or (forms::field-label field) "Submit")))))

(defmethod forms::renderer-render-field-widget
    ((renderer (eql :who))
     (theme bootstrap-form-theme)
     (field forms::choice-form-field) form &rest args)
  (cond
    ((and (forms::field-expanded field)
          (forms::field-multiple field))
     (let ((selected-keys (mapcar #'first (forms::field-keys-and-values field))))
       ;; Render checkboxes
       (with-html-output (*html*)
         (loop for (key . choice) in (forms::field-choices-alist field)
            do
              (htm
               (:input :type "checkbox" :name (forms::render-field-request-name field form)
                       :value key
                       :checked (when (member key selected-keys)
                                  "checked")
                       (str (forms:format-field-value-to-string field
                                     choice))))))))
    ((and (forms::field-expanded field)
          (not (forms::field-multiple field)))
     ;; Render radio buttons
     (let ((selected-value (forms::field-key-and-value field)))
       (with-html-output (*html*)
         (loop for (key . choice) in (forms::field-choices-alist field)
            do
              (htm
               (:input :type "radio" :name (forms::render-field-request-name field form)
                       :value (princ-to-string key)
                       :checked (when (equalp (first selected-value)
                                              key)
                                  "checked")
                       (str (forms:format-field-value-to-string field
                                     choice))))))))
    ((and (not (forms::field-expanded field))
          (forms::field-multiple field))
     ;; A multiple select box
     (let ((selected-keys (mapcar #'first (forms::field-keys-and-values field))))
       (with-html-output (*html*)
         (:select
          :name (forms::render-field-request-name field form)
          :multiple "multiple"
          (loop for (key . choice) in (forms::field-choices-alist field)
             do
               (htm
                (:option :value (princ-to-string key)
                         :selected (when (member key selected-keys)
                                     "selected")
                         (str (forms:format-field-value-to-string field
                                       choice)))))))))
    ((and (not (forms::field-expanded field))
          (not (forms::field-multiple field)))
     ;; A single select box
     (let ((selected-value (forms::field-key-and-value field)))
       (with-html-output (*html*)
         (:select
          :name (forms::render-field-request-name field form)
          :class "form-control"
          (loop for (key . choice) in (forms::field-choices-alist field)
             do
               (htm
                (:option :value (princ-to-string key)
                         :selected (when (equalp (first selected-value)
                                                 key)
                                     "selected")
                         (str (forms:format-field-value-to-string field
                                       choice)))))))))))
