package error

type ErrorHandler interface {
  HandleError(code int, message string)
}
