local snippets = {
  {
    prefix = "pdb",
    desc = "breakpoint()",
    body = "breakpoint()",
  },
  {
    prefix = "exit",
    desc = "sys.exit",
    body = "import sys; sys.exit()",
  },
  {
    prefix = "template-script",
    desc = "Template: Script with traceback",
    body = [[
#!/usr/bin/env python

import traceback
import pdb
import sys

def main():
	# some WIP code that maybe raises an exception
	raise BaseException("oh no, exception!")
	return 0

if __name__ == "__main__":
	try:
		ret = main()
	except:
		traceback.print_exc()
		pdb.post_mortem()
	sys.exit(ret)
]],
  },
}

return snippets
