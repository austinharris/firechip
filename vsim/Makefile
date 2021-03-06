base_dir=$(abspath ..)
sim_dir=$(abspath .)

PROJECT ?= example
MODEL ?= TestHarness
CONFIG ?= DefaultExampleConfig
CFG_PROJECT ?= $(PROJECT)
TB ?= TestDriver

simv = $(sim_dir)/simv-$(PROJECT)-$(CONFIG)
simv_debug = $(sim_dir)/simv-$(PROJECT)-$(CONFIG)-debug

default: $(simv)

debug: $(simv_debug)

include $(base_dir)/Makefrag

rocketchip_vsrc_dir = $(ROCKETCHIP_DIR)/src/main/resources/vsrc

sim_vsrcs = \
	$(build_dir)/$(PROJECT).$(MODEL).$(CONFIG).v \
	$(rocketchip_vsrc_dir)/TestDriver.v \
	$(rocketchip_vsrc_dir)/AsyncResetReg.v \
	$(rocketchip_vsrc_dir)/plusarg_reader.v \
	$(icenet_vsrcs) $(testchip_vsrcs)

sim_csrcs = $(icenet_csrcs) $(testchip_csrcs)

VCS = vcs -full64

VCS_OPTS = -notice -line +lint=all,noVCDE,noONGS,noUI -error=PCWM-L -timescale=1ns/10ps -quiet \
	+rad +v2k +vcs+lic+wait \
	+vc+list -CC "-I$(VCS_HOME)/include" \
	-CC "-I$(RISCV)/include -I$(base_dir)/testchipip/csrc -I$(base_dir)/icenet/csrc" \
	-CC "-std=c++11" \
	-CC "-Wl,-rpath,$(RISCV)/lib" \
	$(RISCV)/lib/libfesvr.so \
	-sverilog \
	+incdir+$(generated_dir) \
	+define+CLOCK_PERIOD=1.0 $(sim_vsrcs) $(sim_csrcs) \
	+define+PRINTF_COND=$(TB).printf_cond \
	+define+STOP_COND=!$(TB).reset \
	+define+RANDOMIZE_MEM_INIT \
	+define+RANDOMIZE_REG_INIT \
	+define+RANDOMIZE_GARBAGE_ASSIGN \
	+define+RANDOMIZE_INVALID_ASSIGN \
	+libext+.v \

verilog: $(sim_vsrcs)

$(simv): $(sim_vsrcs) $(sim_csrcs)
	rm -rf csrc && $(VCS) $(VCS_OPTS) -o $@ \
	-debug_pp

$(simv_debug) : $(sim_vsrcs) $(sim_csrcs)
	rm -rf csrc && $(VCS) $(VCS_OPTS) -o $@ \
	+define+DEBUG -debug_pp

$(output_dir)/%.out: $(output_dir)/% $(simv)
	$(simv) +verbose +max-cycles=1000000 $< 3>&1 1>&2 2>&3 | spike-dasm > $@

$(output_dir)/%.run: $(output_dir)/% $(simv)
	$(simv) +max-cycles=1000000 $< && touch $@

$(output_dir)/%.vpd: $(output_dir)/% $(simv_debug)
	$(simv_debug) +vcdplusfile=$@ +max-cycles=1000000 $<

run-regression-tests: $(addprefix $(output_dir)/,$(addsuffix .out,$(regression-tests)))

run-regression-tests-fast: $(addprefix $(output_dir)/,$(addsuffix .run,$(regression-tests)))

run-regression-tests-debug: $(addprefix $(output_dir)/,$(addsuffix .vpd,$(regression-tests)))

clean:
	rm -rf generated-src csrc simv-* ucli.key vc_hdrs.h

.PHONY: clean
