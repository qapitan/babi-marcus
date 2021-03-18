package = 'babitasks'
version = 'scm-1'
source = {
  url = "git://github.com/qapitan/babi-marcus.git",
  tag = "master"
}
description = {
  summary = "bAbI-tasks: Unit tests for AI",
  license = "Cheese",
  homepage = "https://github.com/facebook/bAbI-tasks"
}

dependencies = {
  "torch >= 7.0",
  "penlight",
  "class"
}

build = {
  type = "builtin",
  install = {
    bin = {
      'babi-tasks-marcus'
    }
  },
  copy_directories = {
    'lua/babi/tasks/worlds'
  },
  modules = {
    babi = "lua/babi/init.lua"
  }
}
