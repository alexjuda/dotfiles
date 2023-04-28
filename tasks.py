from invoke import task


@task
def hello(c, hidden=False):
    extra = []
    if hidden:
        extra.append("-a")

    c.run(f"ls -l {' '.join(extra)}")
