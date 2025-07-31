# setup.R - R Environment Setup Script
# Created: 2025-07-17

cat("🔧 Starting R environment setup...\n")

# Required packages list ----
required_packages <- c(
  "tidyverse",    # Data manipulation & visualization
  "here",         # Path management
  "renv",         # Package management
  "janitor",      # Data cleaning
  "skimr",        # Data overview
  "conflicted",   # Package conflict resolution
  "rmarkdown",    # Report creation
  "knitr",        # Document creation
  "tinytex",      # LaTeX environment management
  "DT",           # Interactive tables
  "plotly",       # Interactive graphs
  "corrplot",     # Correlation matrix visualization
  "GGally",       # Multivariate visualization
  "broom",        # Model results organization
  "glue"          # String manipulation
)

# Install packages if not available
cat("📦 Checking required packages...\n")
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) {
  cat("Installing required packages:", paste(new_packages, collapse = ", "), "\n")
  install.packages(new_packages)
} else {
  cat("✅ All required packages are already installed\n")
}

# LaTeX environment check and setup ----
cat("\n📄 Checking and setting up LaTeX environment...\n")

# TinyTeX check and installation
if (requireNamespace("tinytex", quietly = TRUE)) {
  if (tinytex::is_tinytex()) {
    cat("✅ TinyTeX is already installed\n")
    cat("   Location:", tinytex::tinytex_root(), "\n")
  } else {
    # Check for other LaTeX environments
    other_latex <- tinytex:::find_latex()
    if (length(other_latex) > 0) {
      cat("✅ LaTeX environment found:", other_latex[1], "\n")
    } else {
      cat("❓ No LaTeX environment found\n")
      install_tinytex <- readline("Install TinyTeX? (y/N): ")
      if (tolower(install_tinytex) == "y") {
        cat("📥 Installing TinyTeX... (this may take several minutes)\n")
        tryCatch({
          tinytex::install_tinytex()
          cat("✅ TinyTeX installation completed\n")
        }, error = function(e) {
          cat("❌ TinyTeX installation failed:", e$message, "\n")
        })
      }
    }
  }
  
  # Install Japanese LaTeX packages
  if (tinytex::is_tinytex() || length(tinytex:::find_latex()) > 0) {
    cat("\n📚 Checking Japanese LaTeX packages...\n")
    
    required_latex_packages <- c(
      "luatexja", "luatexja-fontspec", "jlreq", 
      "noto", "noto-cjk", "haranoaji",
      "amsmath", "amssymb", "unicode-math",
      "geometry", "graphicx", "booktabs",
      "longtable", "array", "multirow", "multicol",
      "caption", "subcaption", "hyperref",
      "listings", "xcolor"
    )
    
    # Get all installed packages at once (faster)
    installed_pkgs <- tryCatch({
      result <- system("tlmgr info --only-installed", intern = TRUE, ignore.stderr = TRUE)
      # Extract package names from the output
      pkg_lines <- result[grepl("^[[:alpha:]]", result)]
      gsub(":.*$", "", pkg_lines)
    }, error = function(e) character(0))
    
    missing_packages <- required_latex_packages[!required_latex_packages %in% installed_pkgs]
    
    if (length(missing_packages) > 0) {
      cat("📦 Missing LaTeX packages:", paste(missing_packages, collapse = ", "), "\n")
      install_latex_pkgs <- readline("Install these packages? (y/N): ")
      if (tolower(install_latex_pkgs) == "y") {
        cat("📥 Installing LaTeX packages...\n")
        tryCatch({
          tinytex::tlmgr_install(missing_packages)
          cat("✅ LaTeX packages installation completed\n")
        }, error = function(e) {
          cat("❌ Some packages failed to install\n")
          cat("   Try manually: tinytex::tlmgr_install(c(\"", 
              paste(missing_packages, collapse = "\", \""), "\"))\n")
        })
      }
    } else {
      cat("✅ All required LaTeX packages are installed\n")
    }
  }
} else {
  cat("❌ tinytex package is not available\n")
}

# renv initialization
cat("\n🔒 Initializing renv environment...\n")
if (!file.exists("renv.lock")) {
  if (requireNamespace("renv", quietly = TRUE)) {
    renv::init(force = TRUE)
    cat("✅ renv environment initialized\n")
  } else {
    cat("❌ renv package not found\n")
  }
} else {
  cat("○ renv.lock already exists\n")
  if (requireNamespace("renv", quietly = TRUE)) {
    renv::restore()
    cat("✅ renv environment restored\n")
  }
}

# PDF creation test (optional)
cat("\n🧪 LaTeX environment test (optional)\n")
test_latex <- readline("Test LaTeX environment? (y/N): ")
if (tolower(test_latex) == "y") {
  if (file.exists("manuscript/template.Rmd")) {
    cat("📝 Creating test PDF...\n")
    tryCatch({
      rmarkdown::render("manuscript/template.Rmd", quiet = TRUE)
      if (file.exists("manuscript/template.pdf")) {
        cat("✅ PDF creation successful: manuscript/template.pdf\n")
      } else {
        cat("❌ PDF creation failed\n")
      }
    }, error = function(e) {
      cat("❌ Error during PDF creation:", e$message, "\n")
    })
  } else {
    cat("❌ template.Rmd not found\n")
  }
}

# Project settings confirmation
cat("\n📋 Project Settings Confirmation:\n")
cat("- Working directory:", getwd(), "\n")
cat("- R version:", R.version.string, "\n")

# Package confirmation
cat("\n📚 Main Package Confirmation:\n")
for (pkg in required_packages) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    cat("  ✓", pkg, "\n")
  } else {
    cat("  ✗", pkg, "(not available)\n")
  }
}

# Dataset information display
cat("\n📊 Dataset Information:\n")
datasets <- c("ThaiConsumer", "JapanConsumer")
for (dataset in datasets) {
  path <- here::here("data", "raw", dataset)
  if (dir.exists(path)) {
    cat("  ✓", dataset, "folder exists\n")
  } else {
    cat("  !", dataset, "please place data in folder\n")
  }
}

# conflicted package settings
if (requireNamespace("conflicted", quietly = TRUE)) {
  conflicted::conflict_prefer("filter", "dplyr")
  conflicted::conflict_prefer("select", "dplyr")
  cat("\n⚙️  conflicted package configured\n")
}

cat("\n✅ Setup completed!\n")
cat("\n🚀 Next Steps:\n")
cat("1. Place raw data in data/raw/ folders\n")
cat("2. Start exploration in notebooks/exploratory/\n")
cat("3. Conduct formal analysis in R/analysis/\n")
cat("4. Create Japanese PDF papers with manuscript/template.Rmd\n")
cat("\n📝 Important Files:\n")
cat("- CLAUDE.md: Claude AI conversation log\n")
cat("- docs/analysis_log.md: Analysis process log\n")
cat("- latex/preamble.tex: LaTeX settings file\n")
cat("- manuscript/: Paper writing folder\n")

# LaTeX environment guidance if incomplete
latex_available <- FALSE
if (requireNamespace("tinytex", quietly = TRUE)) {
  latex_available <- tinytex::is_tinytex() || length(tinytex:::find_latex()) > 0
}

if (!latex_available) {
  cat("\n⚠️  LaTeX Environment Setup Help:\n")
  cat("\n【Recommended】TinyTeX (R integrated environment):\n")
  cat("  install.packages(\"tinytex\")\n")
  cat("  tinytex::install_tinytex()\n")
  cat("\n【Alternative】Full LaTeX environment:\n")
  cat("  Windows: TeX Live (https://tug.org/texlive/)\n")
  cat("  macOS: MacTeX (https://tug.org/mactex/)\n")
  cat("  Linux: sudo apt-get install texlive-full\n")
}
