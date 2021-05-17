SPARK_C_SRCS := $(shell find spark/ -name '*.c')
SPARK_C_OBJS := $(patsubst spark/%, obj/$(ARCH)/spark/%.o, $(SPARK_C_SRCS))
SPARK_OBJS := $(SPARK_C_OBJS)
