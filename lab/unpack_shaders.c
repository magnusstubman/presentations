// note: READ_DATA() and DATA_POINTER() return attacker-controllable input

void crUnpackExtendShaderSource(void)
{
    GLint *length = NULL;
    GLuint shader = READ_DATA(8, GLuint);
    GLsizei count = READ_DATA(12, GLsizei);
    GLint hasNonLocalLen = READ_DATA(16, GLsizei);
    GLint *pLocalLength = DATA_POINTER(20, GLint);
    char **ppStrings = NULL;
    GLsizei i, j, jUpTo;
    int pos, pos_check;

    if (count >= UINT32_MAX / sizeof(char *) / 4)
    {
        crError("crUnpackExtendShaderSource: count %u is out of range", count);
        return;
    }

    pos = 20 + count * sizeof(*pLocalLength);

    if (hasNonLocalLen > 0)
    {
        length = DATA_POINTER(pos, GLint);
        pos += count * sizeof(*length);
    }

    pos_check = pos;

    if (!DATA_POINTER_CHECK(pos_check))
    {
        crError("crUnpackExtendShaderSource: pos %d is out of range", pos_check);
        return;
    }

    for (i = 0; i < count; ++i)
    {
        if (pLocalLength[i] <= 0 || pos_check >= INT32_MAX - pLocalLength[i] || !DATA_POINTER_CHECK(pos_check))
        {
            crError("crUnpackExtendShaderSource: pos %d is out of range", pos_check);
            return;
        }

        pos_check += pLocalLength[i];
    }

    ppStrings = crAlloc(count * sizeof(char*));
    if (!ppStrings) return;

    for (i = 0; i < count; ++i)
    {
        ppStrings[i] = DATA_POINTER(pos, char);
        pos += pLocalLength[i];
        if (!length)
        {
            pLocalLength[i] -= 1;
        }

        Assert(pLocalLength[i] > 0);
        jUpTo = i == count -1 ? pLocalLength[i] - 1 : pLocalLength[i];
        for (j = 0; j < jUpTo; ++j)
        {
            char *pString = ppStrings[i];

            if (pString[j] == '\0')
            {
                Assert(j == jUpTo - 1);
                pString[j] = '\n';
            }
        }
    }

//    cr_unpackDispatch.ShaderSource(shader, count, ppStrings, length ? length : pLocalLength);
    cr_unpackDispatch.ShaderSource(shader, 1, (const char**)ppStrings, 0);

    crFree(ppStrings);
}
