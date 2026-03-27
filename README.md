# SOC SPI + I2C Integration Verification

A SystemVerilog UVM-based SOC-level functional verification project that simultaneously verifies both SPI and I2C protocols using a virtual sequencer architecture. The testbench integrates two independent UVM agents under a single SOC environment with a shared configuration object.

---

## Project Structure

```
SOC_SPI_I2C_VERIFICATION/
└── SPI_I2C_INTEGRATION/
    ├── agent_top/
    │   ├── spi_transaction.sv        # SPI UVM sequence item (12-bit din/dout)
    │   ├── spi_sequencer.sv          # SPI UVM sequencer
    │   ├── spi_sequence.sv           # SPI base sequence: 10 random transactions
    │   ├── spi_monitor.sv            # SPI monitor: samples done, din, dout
    │   ├── spi_driver.sv             # SPI driver: drives din and newd to DUT
    │   ├── spi_agent.sv              # SPI agent: config-aware, active/passive support
    │   ├── i2c_xtn.sv                # I2C UVM sequence item (wr, addr, din, datard)
    │   ├── i2c_sequencer.sv          # I2C UVM sequencer
    │   ├── i2c_monitor.sv            # I2C monitor: captures transaction on done
    │   ├── i2c_driver.sv             # I2C driver: drives wr, addr, din; waits for done
    │   ├── i2c_agent.sv              # I2C agent: config-aware, active/passive support
    │   ├── i2c_seqs_base.sv          # I2C base sequence class
    │   ├── i2c_seqs_single_write.sv  # I2C sequence: min boundary write (addr=0x00)
    │   ├── i2c_seqs_single_write1.sv # I2C sequence: max boundary write (addr=0x7F)
    │   ├── i2c_seq_single_read.sv    # I2C sequence: min boundary read (addr=0x01)
    │   ├── i2c_seq_single_read1.sv   # I2C sequence: max boundary read (addr=0x7F)
    │   ├── i2c_write_read_seqs.sv    # I2C sequence: 500 writes then read same addresses
    │   ├── i2c_wr_random_seqs.sv     # I2C sequence: 50 random writes + 50 random reads
    │   └── i2c_wrq_seqs.sv           # I2C sequence: 500 writes + 500 reads from queue
    ├── env/
    │   ├── soc_env_config.sv         # SOC config object: controls agent/scoreboard enables
    │   ├── spi_scb.sv                # SPI scoreboard: compares din vs dout
    │   ├── i2c_scoreboard.sv         # I2C scoreboard: reference model + coverage
    │   ├── soc_virtual_sequencer.sv  # Virtual sequencer: holds spi_sqr and i2c_sqr handles
    │   ├── soc_virtual_sequence.sv   # Virtual sequence base: resolves sequencer handles
    │   ├── soc_virtual_sequence1.sv  # Virtual seq: SPI only
    │   ├── soc_virtual_sequence2.sv  # Virtual seq: SPI + I2C min write
    │   ├── soc_virtual_sequence3.sv  # Virtual seq: SPI + I2C max write
    │   ├── soc_virtual_sequence4.sv  # Virtual seq: SPI + I2C min read
    │   ├── soc_virtual_sequence5.sv  # Virtual seq: SPI + I2C max read
    │   ├── soc_virtual_sequence6.sv  # Virtual seq: SPI + I2C write-read same address
    │   ├── soc_virtual_sequence7.sv  # Virtual seq: SPI + I2C random write-read
    │   ├── soc_virtual_sequence8.sv  # Virtual seq: SPI + I2C random read from queue
    │   └── soc_env.sv                # SOC environment: builds/connects all components
    ├── rtl/
    │   ├── spi_rtl.sv                # SPI RTL: spi_master, spi_slave, top modules
    │   ├── i2c_pkg.sv                # I2C state enum package
    │   ├── i2c_rtl.sv                # I2C RTL: i2c_mem module (master + slave FSM)
    │   ├── i2c_assertion.sv          # I2C SVA: 14 protocol assertions for master/slave
    │   ├── spi_if.sv                 # SPI interface with driver/monitor clocking blocks
    │   └── i2c_if.sv                 # I2C interface
    ├── test/
    │   ├── soc_pkg_file.sv           # Package: imports UVM, includes all TB files
    │   ├── tb_top.sv                 # Top-level testbench: DUTs, interfaces, config DB
    │   ├── soc_test2.sv              # Test: SPI only
    │   ├── soc_test3.sv              # Test: SPI + I2C min boundary write
    │   ├── soc_test4.sv              # Test: SPI + I2C max boundary write
    │   ├── soc_test5.sv              # Test: SPI + I2C min boundary read
    │   ├── soc_test6.sv              # Test: SPI + I2C max boundary read
    │   ├── soc_test7.sv              # Test: SPI + I2C write-read same address
    │   └── soc_test8.sv              # Test: SPI + I2C random write-read
    └── sim/
        └── Makefile                  # Questa Makefile with regression and coverage support
```

---

## Component Descriptions

### Agents

| Component | Description |
|---|---|
| `spi_agent` | Config-aware SPI agent; creates driver+sequencer only if `UVM_ACTIVE` |
| `i2c_agent` | Config-aware I2C agent; creates driver+sequencer only if `UVM_ACTIVE` |
| `soc_env_config` | Central config object controlling which agents/scoreboards are enabled |

### Virtual Sequencer Architecture

```
soc_virtual_sequence (base)
    └── resolves spi_sqr and i2c_sqr from p_sequencer

soc_virtual_sequencer
    ├── spi_sqr  ──► spi_agent.sqr
    └── i2c_sqr  ──► i2c_agent.seqrh
```

### RTL

| Module | Description |
|---|---|
| `spi_master` | Generates SCLK, CS, MOSI; serializes 12-bit data LSB first |
| `spi_slave` | Detects CS, deserializes MOSI, asserts done |
| `i2c_mem` | I2C memory (128 bytes) with master FSM (11 states) + slave FSM |
| `i2c_assertion` | 14 SVA properties checking master/slave FSM transitions and protocol alignment |

---

## Test Scenarios

| Test | Virtual Sequence | SPI | I2C Operation |
|---|---|---|---|
| `soc_test2` | `soc_virtual_sequence1` | 10 random txns | None |
| `soc_test3` | `soc_virtual_sequence2` | 10 random txns | Min boundary write (addr=0x00) |
| `soc_test4` | `soc_virtual_sequence3` | 10 random txns | Max boundary write (addr=0x7F) |
| `soc_test5` | `soc_virtual_sequence4` | 10 random txns | Min boundary read (addr=0x01) |
| `soc_test6` | `soc_virtual_sequence5` | 10 random txns | Max boundary read (addr=0x7F) |
| `soc_test7` | `soc_virtual_sequence6` | 10 random txns | 500 writes then read same addresses |
| `soc_test8` | `soc_virtual_sequence7` | 10 random txns | 50 random writes + 50 random reads |

All tests run SPI and I2C sequences **in parallel** using `fork...join`.

---

## How to Run

Navigate to the `sim/` directory:

```bash
cd SPI_I2C_INTEGRATION/sim
```

### Compile

```bash
make sv_cmp
```

### Run Individual Tests (Batch Mode)

```bash
make run_test2    # SPI only
make run_test3    # SPI + I2C min write
make run_test4    # SPI + I2C max write
make run_test5    # SPI + I2C min read
make run_test6    # SPI + I2C max read
make run_test7    # SPI + I2C write-read
make run_test8    # SPI + I2C random
```

### Run Individual Tests (GUI Mode)

```bash
make run_test2_gui
make run_test3_gui
# ... up to run_test8_gui
```

### Run Full Regression

```bash
make regress
```

Runs all 7 tests and merges coverage into `soc_full_cov.ucdb`.

### View Coverage

```bash
make cov_term    # Summary in terminal
make cov_gui     # Open in Questa GUI
```

### Clean

```bash
make clean
```

---

## Testbench Architecture (UVM)

```
uvm_test (soc_test2 ... soc_test8)
    └── soc_env
          ├── spi_agent
          │     ├── spi_sequencer ◄── soc_virtual_sequencer.spi_sqr
          │     ├── spi_driver ───────► SPI DUT (top)
          │     └── spi_monitor ◄────── SPI DUT (top)
          │           └── mon_ap
          ├── i2c_agent
          │     ├── i2c_sequencer ◄── soc_virtual_sequencer.i2c_sqr
          │     ├── i2c_driver ───────► I2C DUT (i2c_mem)
          │     └── i2c_monitor ◄────── I2C DUT (i2c_mem)
          │           └── mon_port
          ├── spi_scb ◄──── spi_monitor.mon_ap
          ├── i2c_scoreboard ◄──── i2c_monitor.mon_port
          └── soc_virtual_sequencer
                ├── spi_sqr
                └── i2c_sqr
```

---

## Tools Required

- Questa Sim / ModelSim (with UVM support)
- SystemVerilog IEEE 1800 with SVA support
- UVM 1.2 library
