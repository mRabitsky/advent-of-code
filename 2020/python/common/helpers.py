def timer(fn):
    def function_wrapper(*args):
        import datetime

        begin_time = datetime.datetime.now()
        result = fn(*args)
        delta_time = datetime.datetime.now() - begin_time
        print(delta_time)
        return result

    return function_wrapper
